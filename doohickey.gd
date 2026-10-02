extends Control

const BROADCAST_ADDRESS: String = "255.255.255.255"
const BROADCAST_PORT: int = 6769
const PAYLOAD: String = "skibidi"

@onready var label: Label = %Label

var udp_peer: PacketPeerUDP = PacketPeerUDP.new()

var is_server: bool = false
var disable_reuse: bool = false

func _ready() -> void:
	set_process(false)
	for arg in OS.get_cmdline_args():
		if arg == "--server":
			is_server = true
		if arg == "--disablereuse":
			disable_reuse = true


	if is_server:
		start_yelling()
	else:
		listen()
		set_process(true)


func _process(_delta: float) -> void:
	while udp_peer.get_available_packet_count() > 0:
		var packet = udp_peer.get_packet()
		if packet.get_string_from_ascii() == PAYLOAD:
			print("Recieved packet from server!")
			label.text = "I heard a server!"


func start_yelling() -> void:
	udp_peer.set_broadcast_enabled(true)
	udp_peer.set_dest_address(BROADCAST_ADDRESS, BROADCAST_PORT)
	var timer: Timer = Timer.new()
	timer.autostart = true
	timer.timeout.connect(yell)
	add_child(timer)
	label.text = "Actively yelling into the void"


func yell() -> void:
	var packet: PackedByteArray = PAYLOAD.to_ascii_buffer()
	udp_peer.put_packet(packet)


func listen() -> void:
	if !disable_reuse:
		udp_peer.set_reuse_address(true)
		udp_peer.set_reuse_port(true)
	var error: Error = udp_peer.bind(BROADCAST_PORT)
	if error == OK:
		print("Bound to port!")
		label.text = "Listening..."
	else:
		print("Failed to bind to the port!")
