{ config, pkgs, ... }:

let
  # Your custom NBFC fan config (matching the working HP format)
  customConfig = pkgs.writeText "HP-15-bw093ng-Custom.json" (builtins.toJSON {
    LegacyTemperatureThresholdsBehaviour = true;  # Use legacy mode
    NotebookModel = "HP 15-bw093ng Custom Quiet";
    Author = "Custom";
    EcPollInterval = 750;
    ReadWriteWords = false;
    CriticalTemperature = 85;
    FanConfigurations = [{
      ReadRegister = 17;
      WriteRegister = 25;
      MinSpeedValue = 3;
      MaxSpeedValue = 54;
      IndependentReadMinMaxValues = true;
      MinSpeedValueRead = 5;
      MaxSpeedValueRead = 62;
      ResetRequired = false;
      FanSpeedResetValue = 0;
      FanDisplayName = "Main Fan";
      # NO TemperatureThresholds - legacy mode handles it automatically
    }];
    RegisterWriteConfigurations = [{
      WriteMode = "Set";
      WriteOccasion = "OnInitialization";
      Register = 21;
      Value = 1;
      ResetRequired = true;
      ResetValue = 0;
      ResetWriteMode = "Set";
      Description = "Manual Override";
    }];
  });

  # Override nbfc-linux to include your custom config
  nbfc-with-custom = pkgs.nbfc-linux.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      cp ${customConfig} $out/share/nbfc/configs/HP-15-bw093ng-Custom.json
    '';
  });

  # NBFC config selector file
  nbfcConfigFile = pkgs.writeText "nbfc.json" (builtins.toJSON {
    SelectedConfigId = "HP-15-bw093ng-Custom";
  });

in
{
  # Enable EC write support for fan control
  boot.extraModprobeConfig = ''
    options ec_sys write_support=1
  '';
  
  boot.kernelModules = [ "ec_sys" ];

  # Install nbfc-linux with custom config
  environment.systemPackages = [
    nbfc-with-custom
    pkgs.kmod
  ];

  # NBFC service
  systemd.services.nbfc_service = {
    enable = true;
    description = "NoteBook FanControl service";
    serviceConfig = {
      Type = "simple";
    };
    path = [ pkgs.kmod ];
    script = "${nbfc-with-custom}/bin/nbfc_service --config-file ${nbfcConfigFile}";
    wantedBy = [ "multi-user.target" ];
  };
}

