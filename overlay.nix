# You can use this file as a nixpkgs overlay. This is useful in the
# case where you don't want to add the whole cbspkgs namespace to your
# configuration.

self: super:

let

  isReserved = n:
    n == "lib" || n == "modules" || n == "nixpkgs" || n == "overlays";
  nameValuePair = name: value: { inherit name value; };
  cbspkgs = import ./default.nix { pkgs = super; };

in with builtins;

{
  cbspkgs = listToAttrs (map
    (name: nameValuePair name cbspkgs.${name})
    (filter
      (name: !isReserved name)
      (attrNames cbspkgs)
    )
  );
}
