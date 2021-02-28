# lotus-flake

nixOS Flake for Lotus

# Usage

Add it to inputs like so

```
inputs.lotus.url = "github:mkg20001/lotus-flake/master";
```

And use the module

```
{ ... , lotus }:
  ...
  modules = [
    lotus.nixosModules.lotus
    ({ ... }: {
      nixpkgs.overlays = [ lotus.overlay ];
      services.lotus.enable = true;
    })
  ];
  ...
```
