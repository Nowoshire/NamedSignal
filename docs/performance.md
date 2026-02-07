# Performance
NamedSignal utilizes standard optimizations, such as thread recycling and linked lists. As such, most features of NamedSignal have comparable performance to other implementations — with the exception of `Signal:Fire()`*, which is roughly 4-5x faster than others according to benchmarks.

<small>
*I am unable to figure out how NamedSignal's Fire is faster, as I do not implement any additional optimizations.
<br>If there is a bug, or you cannot reproduce these results, please submit an [issue](https://github.com/Nowoshire/NamedSignal/issues)!
</small>

## Benchmarks
Benchmarked with the included `Benchmark.rbxm`, and with the following details:

- Windows 11 Pro Build 26200
- Roblox Studio Version 0.706.0.7060750
- Ryzen 7 5700X3D 8-Core Processor
- 32GB DDR4 3200MT/s (4x8)

All libraries were benchmarked with their respective immediate modes instead of deferred modes if applicable.

=== "NamedSignal (Immediate)"

	### NamedSignal (Immediate)
	#### Signal.new()
	254.60001779720187 µs (10000 call total)

	#### Signal:Connect()
	733.4999972954392 µs (5000 call total)

	#### Signal:Fire()
	| Connection Count | Time (200 call average) |
	| --- | --- |
	| 0 connections | 0.03850000211969018 µs |
	| 1 connections | 0.15249999705702066 µs |
	| 100 connections | 10.957500198855996 µs |
	| 1000 connections | 108.5195000632666 µs |
	| 5000 connections | 580.0900000031106 µs |

	#### Signal:Disconnect()
	| Connection Count | Time (5000 disconnects) |
	| --- | --- |
	| 5000 to 0 connections | 446.9000268727541 µs |
	| 11000 to 6000 connections | 338.70001789182425 µs |
	| 15000 to 10000 connections | 278.40002439916134 µs |

	#### Signal:DisconnectAll()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.07760000880807638 µs |
	| 100 connections | 2.23060033749789 µs |
	| 1000 connections | 20.423398236744106 µs |
	| 5000 connections | 99.65059999376535 µs |

	#### Signal:Destroy()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.1570003805682063 µs |
	| 100 connections | 2.3032001918181777 µs |
	| 1000 connections | 22.739999229088426 µs |
	| 5000 connections | 102.84220054745674 µs |

=== "SignalPlus (Immediate)"

	### SignalPlus (Immediate)
	#### Signal.new()
	267.9999452084303 µs (10000 call total)

	#### Signal:Connect()
	440.1000333018601 µs (5000 call total)

	#### Signal:Fire()
	| Connection Count | Time (200 call average) |
	| --- | --- |
	| 0 connections | 0.03950000973418355 µs |
	| 1 connections | 0.5000000237487257 µs |
	| 100 connections | 47.06300009274855 µs |
	| 1000 connections | 453.9959999965504 µs |
	| 5000 connections | 2252.3745000944473 µs |

	#### Signal:Disconnect()
	| Connection Count | Time (5000 disconnects) |
	| --- | --- |
	| 5000 to 0 connections | 243.99999529123306 µs |
	| 11000 to 6000 connections | 242.9999876767397 µs |
	| 15000 to 10000 connections | 224.19996093958616 µs |

	#### Signal:DisconnectAll()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.08100003469735384 µs |
	| 100 connections | 1.9846011418849232 µs |
	| 1000 connections | 19.81779746711254 µs |
	| 5000 connections | 104.08740036655217 µs |

	#### Signal:Destroy()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.16399985179305077 µs |
	| 100 connections | 2.0871999440714717 µs |
	| 1000 connections | 20.494997268542647 µs |
	| 5000 connections | 102.39319957327098 µs |

=== "FastSignal (Immediate)"

	### FastSignal (Immediate)
	#### Signal.new()
	560.4999605566263 µs (10000 call total)

	#### Signal:Connect()
	596.199999563396 µs (5000 call total)

	#### Signal:Fire()
	| Connection Count | Time (200 call average) |
	| --- | --- |
	| 0 connections | 0.07349997758865356 µs |
	| 1 connections | 0.5055000656284392 µs |
	| 100 connections | 44.73799985134974 µs |
	| 1000 connections | 427.88949998794124 µs |
	| 5000 connections | 2117.3549999366514 µs |

	#### Signal:Disconnect()
	| Connection Count | Time (5000 disconnects) |
	| --- | --- |
	| 5000 to 0 connections | 260.7000060379505 µs |
	| 11000 to 6000 connections | 258.39998852461576 µs |
	| 15000 to 10000 connections | 257.7000414021313 µs |

	#### Signal:DisconnectAll()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.07239985279738903 µs |
	| 100 connections | 1.7841983353719115 µs |
	| 1000 connections | 16.819598735310137 µs |
	| 5000 connections | 87.67940162215382 µs |

	#### Signal:Destroy()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.09720004163682461 µs |
	| 100 connections | 1.844600890763104 µs |
	| 1000 connections | 17.400998855009675 µs |
	| 5000 connections | 88.17239885684103 µs |

=== "GoodSignal"

	### GoodSignal
	#### Signal.new()
	599.0000208839774 µs (10000 call total)

	#### Signal:Connect()
	721.2000200524926 µs (5000 call total)

	#### Signal:Fire()
	| Connection Count | Time (200 call average) |
	| --- | --- |
	| 0 connections | 0.0344999716617167 µs |
	| 1 connections | 0.5609999061562121 µs |
	| 100 connections | 49.47449982864782 µs |
	| 1000 connections | 487.85299994051456 µs |
	| 5000 connections | 2613.876500108745 µs |

	#### Signal:Disconnect()
	| Connection Count | Time (5000 disconnects) |
	| --- | --- |
	| 5000 to 0 connections | 134394.79999942705 µs |
	| 11000 to 6000 connections | 457752.29996070266 µs |
	| 15000 to 10000 connections | 352137.3000112362 µs |

	#### Signal:DisconnectAll()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.051800161600112915 µs |
	| 100 connections | 0.07639988325536251 µs |
	| 1000 connections | 0.090000219643116 µs |
	| 5000 connections | 0.11980021372437477 µs |

	#### Signal:Destroy()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| N/A: No Signal:Destroy() |