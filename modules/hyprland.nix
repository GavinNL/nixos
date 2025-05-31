# Following the official recommendations to 
# use Hyrpland plugins using flakes
#
#
# https://github.com/hyprwm/hyprland-plugins
#
# Error is given below:
#
{ lib, pkgs, inputs, ... }:
with lib; let
  hyprPluginPkgs = inputs.hyprland-plugins.packages.${pkgs.system};
  hypr-plugin-dir = pkgs.symlinkJoin {
    name = "hyrpland-plugins";
    paths = with hyprPluginPkgs; [
      hyprexpo
      #...plugins
    ];
  };
in
{
  environment.sessionVariables = { HYPR_PLUGIN_DIR = hypr-plugin-dir; };
}


#error:
#       … while calling the 'head' builtin
#         at /nix/store/01635adignbizr4nyz5lpawkrxn4n4g8-source/lib/attrsets.nix:1534:13:
#         1533|           if length values == 1 || pred here (elemAt values 1) (head values) then
#         1534|             head values
#             |             ^
#         1535|           else
#
#       … while evaluating the attribute 'value'
#         at /nix/store/01635adignbizr4nyz5lpawkrxn4n4g8-source/lib/modules.nix:1084:7:
#         1083|     // {
#         1084|       value = addErrorContext "while evaluating the option `${showOption loc}':" value;
#             |       ^
#         1085|       inherit (res.defsFinal') highestPrio;
#
#       … while evaluating the option `system.build.toplevel':
#
#      … while evaluating definitions from `/nix/store/01635adignbizr4nyz5lpawkrxn4n4g8-source/nixos/modules/system/activation/top-level.nix':
#
#       … while evaluating the option `system.systemBuilderArgs':
#
#       … while evaluating definitions from `/nix/store/01635adignbizr4nyz5lpawkrxn4n4g8-source/nixos/modules/system/activation/activatable-system.nix':
#
#       … while evaluating the option `system.activationScripts.etc.text':
#
#       … while evaluating definitions from `/nix/store/01635adignbizr4nyz5lpawkrxn4n4g8-source/nixos/modules/system/etc/etc-activation.nix':
#
#       … while evaluating definitions from `/nix/store/01635adignbizr4nyz5lpawkrxn4n4g8-source/nixos/modules/system/etc/etc.nix':
#
#       … while evaluating the option `environment.etc."pam/environment".source':
#
#       … while evaluating definitions from `/nix/store/01635adignbizr4nyz5lpawkrxn4n4g8-source/nixos/modules/system/etc/etc.nix':
#
#       … while evaluating the option `environment.etc."pam/environment".text':
#
#       … while evaluating definitions from `/nix/store/01635adignbizr4nyz5lpawkrxn4n4g8-source/nixos/modules/config/system-environment.nix':
#
#       … while evaluating the option `environment.sessionVariables':
#
#       (stack trace truncated; use '--show-trace' to show the full, detailed trace)
#
#       error: undefined variable 'inputs'
#       at /nix/store/qrsx3aqj32ncr7z0jkgbw0y18an4ayp2-source/modules/hyprland.nix:13:20:
#           12| with lib; let
#           13|   hyprPluginPkgs = inputs.hyprland-plugins.packages.${pkgs.system};
#             |                    ^
#           14|   hypr-plugin-dir = pkgs.symlinkJoin {

