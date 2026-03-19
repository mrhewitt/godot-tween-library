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
		

## Center the given Cpntrol pivot point[br]
## [color=RED]Works only for Control nodes![/color]
## [i]Tweens using scaling/reotation/etc all require pivot point to be centrol[br]
## unless you are going for an unusual effect[/i]
## [color=YELLOW]Note pivot points are NOT automatically centered by tween methods[/color]
static func set_pivot_center( target: Control ) -> void:
	target.pivot_offset = target.size / 2.0

#endregion

#region Main Tweener Animations

## Fade out effect via modulate alpha, resets alpha to 1.0 and hides node on completion
## so node can become visible again simply by setting visible, no need to manage alpha outside
##
## [param fade_time]  Duration of the effect
## [param start_delay]  Option delay to incur before the fade effect begins
static func fadeout( target: CanvasItem, fade_time: float, start_delay: float = 0.0 ) -> Tween:
	return fadeout_tween( create_tween(target), target, fade_time, start_delay )
	

## Creates a pop out effect
## [param scale_factor] is amount by which default scale is adjusted
## [param duration] Total duration of the effect
static func pop( target: CanvasItem, scale_factor: float = 1.3, duration: float = 0.3):
	return pop_tween( create_tween(target), target, scale_factor, duration )


## Creates a little hop effect
## [param height] Number of pixels to jump up by
## [param duration] Total time, goes up in half duration, back down in same
## [param loops] Set to true to have the motion repeated forever
static func bounce( target: CanvasItem, height: int = 10, duration: float = 0.3, loop: bool = false) -> Tween:
	return bounce_tween( create_tween(target), target, height, duration, loop)
	

## Animate a property on a shader material in the target node[br]
## [i]Assumes animation will be applied to target.material[/i]
## [param property] is name of actual shader parameter, e.g. progress
static func tween_shader_property( target: CanvasItem, property: String, final_value, duration: float ) -> Tween:
	return tween_shader_property_tween( create_tween(target), target, property, final_value, duration )


## Animate a pulsing effect, usually on buttons etc that scale in and out
## [param duration] Length of entire effect
static func pulse( target: CanvasItem, scale_by: float = 1.1, duration: float = 1) -> Tween:
	return pulse_tween( create_tween(target), target, scale_by, duration )
	
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


## Creates a pop out effect
## [param scale_factor] is amount by which default scale is adjusted
## [param duration] Total duration of the effect
static func pop_tween( tween: Tween, target: CanvasItem, scale_factor: float = 1.3, duration: float = 0.3) -> Tween:
	var original_scale = target.scale
	tween.tween_property(target, "scale", original_scale * scale_factor, duration/2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "scale", original_scale, duration/2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	return tween
	

## Creates a little hop effect
## [param height] Number of pixels to jump up by
## [param duration] Total time, goes up in half duration, back down in same
## [param loops] Set to true to have the motion repeated forever
static func bounce_tween( tween: Tween, target: CanvasItem, height: int = 10, duration: float = 0.3, loop: bool = false) -> Tween:
	var default_y: int = target.position.y
	if loop:
		tween.set_loops()
	tween.tween_property(target, "position:y", default_y - height, duration / 2)
	tween.tween_property(target, "position:y", default_y, duration / 2)
	return tween


## Animate a property on a shader material in the target node[br]
## [i]Assumes animation will be applied to target.material[/i]
## [param property] is name of actual shader parameter, e.g. progress
static func tween_shader_property_tween( tween: Tween, target: CanvasItem, property: String, final_value, duration: float ) -> Tween:
	tween.tween_property(target.material, "shader_parameter/" + property, final_value, duration)
	return tween
	
	
## Animate a pulsing effect, usually on buttons etc that scale in and out
## [param duration] Length of entire effect
static func pulse_tween( tween: Tween, target: CanvasItem, scale_by: float = 1.1, duration: float = 8.0) -> Tween:
	tween.set_loops()
	tween.tween_property( target, "scale", target.scale * scale_by, duration/2.0 )
	tween.tween_property( target, "scale", target.scale, duration/2.0 )
	return tween
	
	
#endregion
