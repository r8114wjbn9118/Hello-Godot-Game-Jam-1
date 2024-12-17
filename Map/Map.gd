@tool
class_name Map extends Node2D 



var _undo_redo = UndoRedo.new() # 命令模式

func Build( points:Array[Vector2i] ) -> void: #初始化
	pass

func Do( vec:Vector2i ):
	pass
func Reset():
	pass
func Undo():
	pass
func Redo():
	pass

#region TEST ZONE

@export var size:Vector2i = Vector2i(7,7): # TEST
	set(new):
		size = new
		_update_childs()
var time:float = 0.0
func _process(delta: float) -> void:
	time += delta
	if time >=0.3:
		time = 0.0
		_update_childs()

func _ready() -> void:
	_update_childs()

func _update_childs():
	var tileMap:TileMapLayer
	for i in get_children():
		if i.is_in_group("TileMap"):
			i.position = Vector2.ONE*-50
			tileMap = i
	
	var points:Array[Vector2] = []
	if tileMap:
		for i in tileMap.get_used_cells():
			points.append(Vector2(i))
	else:
		for i in range(size.x):
			for j in range(size.y):
				points.append(Vector2(i, j))
	_build(points)
	_scan_nodes()
	
	for i in get_children():
		if !(i.is_in_group("Worm") or i.is_in_group("Eye") or i.is_in_group("TileMap")):
			i.queue_free()
	var root = Node2D.new()
	add_child(root)
	for i in _points:
		var node = Sprite2D.new()
		node.scale/=5.0
		node.texture = preload("res://icon.svg")
		node.position = i.getPos() * CELL_SIZE
		root.add_child(node)
	for i in _edges:
		var node = Line2D.new()
		node.points = [i._p1.getPos()*CELL_SIZE, i._p2.getPos()*CELL_SIZE]
		root.add_child(node)
	
	for i in _worm_points:
		var node = Sprite2D.new()
		node.scale/=2.0
		node.texture = preload("res://icon.svg")
		node.position = i.getPos() * CELL_SIZE
		root.add_child(node)
	for i in _eye_edges:
		var node = Line2D.new()
		node.modulate = Color.RED
		node.points = [i._p1.getPos()*CELL_SIZE, i._p2.getPos()*CELL_SIZE]
		root.add_child(node)
#endregion
	




func _scan_nodes(): # 掃描子節點並設定_eye_edges和_worm_points的位置
	var worms_pos:Array[Vector2] = _childs_in_ths_group("Worm")
	var eyes_pos:Array[Vector2] = _childs_in_ths_group("Eye")
	for i in worms_pos:
		_set_worm_point(i)
	for i in eyes_pos:
		_set_eye_point(i)

func _childs_in_ths_group(group_name:String) -> Array[Vector2]: # world pos
	var arr:Array[Vector2] = []
	for child in get_children():
		if child.is_in_group(group_name):
			arr.append((child as Node2D).position)
	return arr

func _set_worm_point(pos:Vector2):
	pos/=CELL_SIZE
	var closest = _points[0]
	for i:Point in _points:
		if (i.getPos()-pos).length() < (closest.getPos()-pos).length():
			closest = i
	#print("set worm point", closest.getPos())
	_worm_points.append(closest)

func _set_eye_point(pos:Vector2):
	pos = (pos/CELL_SIZE).floor() + Vector2.ONE/2.0
	var _comp = func(A:Edge, B:Edge):
		var a_center = (A._p1.getPos() + A._p2.getPos())/2.0
		var b_center = (B._p1.getPos() + B._p2.getPos())/2.0
		return (a_center-pos).length() < (b_center-pos).length()
	_edges.sort_custom(_comp)
	if _edges.size()>=4:
		_eye_edges.append(_edges[0])
		_eye_edges.append(_edges[1])
		_eye_edges.append(_edges[2])
		_eye_edges.append(_edges[3])


const CELL_SIZE:Vector2 = Vector2.ONE * 100.0 # 單元格大小

var _points:Array[Point] = []
var _edges:Array[Edge] = []

var _eye_edges:Array[Edge] = []
var _worm_points:Array[Point] = []

func _build( points:Array[Vector2]) -> void: #初始化 _points & _edges _worm_points _eye_edges
	_worm_points.clear()
	_eye_edges.clear()
	_points.clear()
	_edges.clear()
	for point:Vector2 in points: # 新增所有點
		_points.append(Point.new(point))
	
	var isMyEdge = func(p1:Point, p2:Point) -> bool: #只新增距離為一且位於 右or下 的邊
		var dist:int = p1.distTo(p2)
		var angle:float = (p2.getPos() - p1.getPos()).angle()
		const ev:float = PI/30.0
		#print("dist:{0} angle:{1}".format([dist, angle]))
		return dist == 1 and (angle >= 0.0-ev and angle <= PI/2.0+ev)
			
	for point:Point in _points: # 為所有點新增邊
		for secPoint:Point in _points:
			if isMyEdge.call(point, secPoint):
				_edges.append(point.addEdge(secPoint))



class Point:
	func _init( pos:Vector2 ) -> void:
		_pos = pos
	
	func distTo( p:Point ) -> int: # 曼哈頓距離
		return abs(self.getPos().x - p.getPos().x) + abs(self.getPos().y - p.getPos().y)
	
	func getPos() -> Vector2:
		return _pos
	
	func addEdge( sec:Point ) -> Edge:
		var edge = Edge.new(self, sec)
		_edges.append(edge)
		return edge
	
	var _pos:Vector2 # map pos
	var _edges:Array[Edge]
	
class Edge:
	func _init(p1:Point, p2:Point) -> void:
		_p1 = p1
		_p2 = p2
		#print("add Edge!")
	
	var _p1:Point # map pos
	var _p2:Point
	







#
