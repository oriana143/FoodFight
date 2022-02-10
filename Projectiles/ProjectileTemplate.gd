extends RigidBody

var fired_by

func _on_ProjectileTemplate_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.has_method("hurt"):
		body.hurt(fired_by)
		queue_free()
