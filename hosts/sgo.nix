{ lib, inputs, ... }:
lib.mkHost {
  name = "sgo";
  extraModules = [
    inputs.nixos-hardware.nixosModules.microsoft-surface-go
    (inputs.self + "/hw/sgo/disk-config.nix")
    (
      { pkgs, ... }:
      {
        boot.kernelParams = [ "usbcore.autosuspend=-1" ];
        # prevent overheat/shutdown
        #
        # The Surface firmware exposes no ACPI thermal trip points
        # ("[Firmware Bug]: No valid trip points!") and no DPTF/GDDV adaptive
        # tables, so with the stock config thermald never throttles until
        # right at TjMax -- by which point the machine has already hard-locked.
        # Give it an explicit passive trip at 75C on the package sensor,
        # throttling via RAPL first, then p-states, then idle injection.
        services.thermald = {
          enable = true;
          configFile = pkgs.writeText "thermal-conf.xml" ''
            <?xml version="1.0"?>
            <ThermalConfiguration>
            <Platform>
              <Name>Surface Go 2 overheat guard</Name>
              <ProductName>*</ProductName>
              <Preference>QUIET</Preference>
              <ThermalZones>
                <ThermalZone>
                  <Type>cpu</Type>
                  <TripPoints>
                    <TripPoint>
                      <SensorType>x86_pkg_temp</SensorType>
                      <Temperature>75000</Temperature>
                      <type>passive</type>
                      <ControlType>SEQUENTIAL</ControlType>
                      <CoolingDevice>
                        <index>1</index>
                        <type>rapl_controller</type>
                        <influence>100</influence>
                        <SamplingPeriod>2</SamplingPeriod>
                      </CoolingDevice>
                      <CoolingDevice>
                        <index>2</index>
                        <type>intel_pstate</type>
                        <influence>50</influence>
                        <SamplingPeriod>2</SamplingPeriod>
                      </CoolingDevice>
                      <CoolingDevice>
                        <index>3</index>
                        <type>intel_powerclamp</type>
                        <influence>40</influence>
                        <SamplingPeriod>3</SamplingPeriod>
                      </CoolingDevice>
                    </TripPoint>
                  </TripPoints>
                </ThermalZone>
              </ThermalZones>
            </Platform>
            </ThermalConfiguration>
          '';
        };
      }
    )
  ];
}
