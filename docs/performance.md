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
	293.0999999080086 µs (10000 call total)

	#### Signal:Connect()
	713.000000359898 µs (5000 call total)

	#### Signal:Once()
	913.800000489573 µs (5000 call total)

	#### Signal:Wait()
	1418.2000004439033 µs (5000 call total)

	#### Signal:Fire()
	| Connection Count | Time (200 call average) |
	| --- | --- |
	| 0 connections | 0.04450000233191531 µs |
	| 1 connections | 0.15999999959603883 µs |
	| 100 connections | 10.810500002662593 µs |
	| 1000 connections | 110.34500000278058 µs |
	| 5000 connections | 550.5834999985382 µs |

	#### Signal:Disconnect()
	| Connection Count | Time (5000 disconnects) |
	| --- | --- |
	| 5000 to 0 connections | 332.3999999338412 µs |
	| 11000 to 6000 connections | 342.50000044266926 µs |
	| 15000 to 10000 connections | 306.2999994654092 µs |

	#### Signal:DisconnectAll()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.0878000046213856 µs |
	| 100 connections | 2.240600000732229 µs |
	| 1000 connections | 19.955399991886225 µs |
	| 5000 connections | 99.18940003444732 µs |

	#### Signal:Destroy()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.16340000183845405 µs |
	| 100 connections | 2.2328000031848205 µs |
	| 1000 connections | 19.69119998102542 µs |
	| 5000 connections | 98.56499997476931 µs |

=== "SignalPlus (Immediate)"

	### SignalPlus (Immediate)
	#### Signal.new()
	472.49999988707714 µs (10000 call total)

	#### Signal:Connect()
	506.3999997219071 µs (5000 call total)

	#### Signal:Once()
	872.1000003788504 µs (5000 call total)

	#### Signal:Wait()
	1176.800000393996 µs (5000 call total)

	#### Signal:Fire()
	| Connection Count | Time (200 call average) |
	| --- | --- |
	| 0 connections | 0.03949999609176302 µs |
	| 1 connections | 0.6195000014486141 µs |
	| 100 connections | 45.51250000076834 µs |
	| 1000 connections | 451.3489999999365 µs |
	| 5000 connections | 2253.7010000041846 µs |

	#### Signal:Disconnect()
	| Connection Count | Time (5000 disconnects) |
	| --- | --- |
	| 5000 to 0 connections | 234.30000055668643 µs |
	| 11000 to 6000 connections | 241.49999990186188 µs |
	| 15000 to 10000 connections | 230.10000040812884 µs |

	#### Signal:DisconnectAll()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.1246000119863311 µs |
	| 100 connections | 1.9977999927505155 µs |
	| 1000 connections | 19.31200000581157 µs |
	| 5000 connections | 98.0693999936193 µs |

	#### Signal:Destroy()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.1739999916026136 µs |
	| 100 connections | 2.0981999914511107 µs |
	| 1000 connections | 19.709000009243027 µs |
	| 5000 connections | 98.99919998315454 µs |

=== "FastSignal (Immediate)"

	### FastSignal (Immediate)
	#### Signal.new()
	445.7000004549627 µs (10000 call total)

	#### Signal:Connect()
	782.1999997759121 µs (5000 call total)

	#### Signal:Once()
	812.6000002448563 µs (5000 call total)

	#### Signal:Wait()
	3521.999999975378 µs (5000 call total)

	#### Signal:Fire()
	| Connection Count | Time (200 call average) |
	| --- | --- |
	| 0 connections | 0.049000000217347406 µs |
	| 1 connections | 0.4875000013271347 µs |
	| 100 connections | 43.87949999909324 µs |
	| 1000 connections | 468.44399999827147 µs |
	| 5000 connections | 2132.1844999965833 µs |

	#### Signal:Disconnect()
	| Connection Count | Time (5000 disconnects) |
	| --- | --- |
	| 5000 to 0 connections | 251.80000011459924 µs |
	| 11000 to 6000 connections | 251.7000002626446 µs |
	| 15000 to 10000 connections | 255.40000024193432 µs |

	#### Signal:DisconnectAll()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.0712000073690433 µs |
	| 100 connections | 1.8486000244593015 µs |
	| 1000 connections | 16.75280002200452 µs |
	| 5000 connections | 85.32660000309988 µs |

	#### Signal:Destroy()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.09380000483361073 µs |
	| 100 connections | 1.9170000050507952 µs |
	| 1000 connections | 17.063200009943102 µs |
	| 5000 connections | 86.44400002049224 µs |

=== "GoodSignal"

	### GoodSignal
	#### Signal.new()
	576.1000002166838 µs (10000 call total)

	#### Signal:Connect()
	789.4999998825369 µs (5000 call total)

	#### Signal:Once()
	1106.2999992645928 µs (5000 call total)

	#### Signal:Wait()
	1332.8000004548812 µs (5000 call total)

	#### Signal:Fire()
	| Connection Count | Time (200 call average) |
	| --- | --- |
	| 0 connections | 0.03499999820633093 µs |
	| 1 connections | 0.5694999981642468 µs |
	| 100 connections | 41.92849999981263 µs |
	| 1000 connections | 484.88150000139285 µs |
	| 5000 connections | 2494.465999998283 µs |

	#### Signal:Disconnect()
	| Connection Count | Time (5000 disconnects) |
	| --- | --- |
	| 5000 to 0 connections | 132245.3000002497 µs |
	| 11000 to 6000 connections | 446723.50000018923 µs |
	| 15000 to 10000 connections | 346957.09999959945 µs |

	#### Signal:DisconnectAll()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.04919999810226727 µs |
	| 100 connections | 0.057599992942414246 µs |
	| 1000 connections | 0.07960003313201014 µs |
	| 5000 connections | 0.11879999328812119 µs |

	#### Signal:Destroy()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| N/A: No Signal:Destroy() |