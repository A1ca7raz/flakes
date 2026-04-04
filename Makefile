disko:
	nix --experimental-features 'nix-command flakes' build .#nixosConfigurations.${PRF}.config.system.build.disko

update:
	nix flake update
	sudo nixos-rebuild switch --flake .#${PRF}

bump:
	git add flake.lock
	git commit -m "Bump flake.lock"

noctalia:
	@echo "Export Noctalia settings"
	@noctalia-shell ipc call state all | jq .settings > modules/desktop/noctalia/config.json
	@cp ~/.config/noctalia/plugins.json modules/desktop/noctalia/plugins.json
