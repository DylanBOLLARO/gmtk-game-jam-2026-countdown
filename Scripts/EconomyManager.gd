extends Node

# signals
signal gold_changed

# variables
var gold: float = 0
var gold_gained_this_second: float = 0

func add_gold(amount: float):
	gold += amount
	
	if amount > 0:
		gold_gained_this_second += amount
		
	emit_signal("gold_changed")

func can_purchase(amount: float):
	return gold >= amount

func get_gold_per_second() -> float:
	var total = 0.0
	
	for farmer in PurchaseManager.owned_farmers.values():
		var data = farmer.get("data")
		var amount = farmer.get("amount")
		var enum_name = data.type
		var local_stats:FarmerStats
		
		var per_second = data.stats.gold_per_second
		var multiplier = data.stats.gold_multiplier
		
		for it_upgrade in PurchaseManager.owned_upgrades:
			if it_upgrade.apply_to.has(enum_name):
				local_stats = it_upgrade.stats
				
		if local_stats:
			per_second += local_stats.gold_per_second
			multiplier = local_stats.gold_multiplier
		
		total += per_second * multiplier * amount
	return total
