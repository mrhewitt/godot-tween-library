class_name TweenHelper extends RefCounted
## Static class providing a collection of common tween animations
##
## Usage (static class only)
## ────────────────────────────────────────────────
## Implemented as a pure static class, no need to setup autoloads etc
## Simply access via the class name from anywhere:
##
##   TweenHelper.fadeout( $Sprite2D, 1, 1 )
##
## All functions come in two variarions:
##     xxx( node_to_tween, .... )
##   and
##     xxx_tween( valid_tween, node_to_tween, .... )
##
## The firsts instance automatically creates a Tween from the given target node,
## the second will use the provided tween, can be useful in cases where we want
## tween to be parented to another node or initialized in another way 
##
##
## =========================================================
## Provides tweens:
## ────────────────────────────────────────────────
##		fadeout - 
##
##
##
##
##
## =========================================================

#region Support methods


## Returns true if the target is a valid node
static func is_valid_target( target: CanvasItem ) -> bool:
	return target and is_instance_valid(target)


## Create and return a new tweener, null if target is not valid
static func create_tween( target: CanvasItem ) -> Tween:
	return target.create_tween() if is_valid_target(target) else null
	
	
#endregion

#region Main Tweener Animations

## Fade out effect via modulate alpha, resets alpha to 1.0 and hides node on completion
## so node can become visible again simply by setting visible, no need to manage alpha outside
##
## [param fade_time]  Duration of the effect
## [param start_delay]  Option delay to incur before the fade effect begins
static func fadeout( target: CanvasItem, fade_time: float, start_delay: float = 0.0 ) -> Tween:
	return fadeout_tween( create_tween(target), target, fade_time, start_delay )
	

#endregion

#region Tweener Versions

## Fade out effect via modulate alpha, resets alpha to 1.0 and hides node on completion
## so node can become visible again simply by setting visible, no need to manage alpha outside
##
## [param fade_time]  Duration of the effect
## [param start_delay]  Option delay to incur before the fade effect begins
static func fadeout_tween( tween: Tween, target: CanvasItem, fade_time: float, start_delay: float = 0.0 )  -> Tween:
	if start_delay > 0.0:
		tween.tween_interval(start_delay)
	tween.tween_property(target, "modulate:a", 0.0, 1)
	tween.tween_property(target,"visible", false, 0)
	# restore modulate property so next time the target is made visible
	# caller does not have to manage module property
	tween.tween_property(target, "modulate:a", 1.0, 0)
	return tween

#endregion
