require("T6.Zombie.ammoareazombieOG")

CoD.AmmoAreaZombie.UpdateWeapon = function (f12_arg0, f12_arg1)
	if f12_arg1.weapon and (Engine.IsWeaponType(f12_arg1.weapon, "melee") or Engine.IsWeaponType(f12_arg1.weapon, "riotshield") or Engine.IsWeaponType(f12_arg1.weapon, "grenade")) or (f12_arg1.inventorytype == 2) then
		f12_arg0.hideAmmo = true
	else
		f12_arg0.hideAmmo = nil
	end
	CoD.AmmoAreaZombie.UpdateVisibility(f12_arg0, f12_arg1)
	f12_arg0:dispatchEventToChildren(f12_arg1)
end
