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
	375.99999996018596 µs (10000 call total)

	#### Signal:Connect()
	467.9000012401957 µs (5000 call total)

	#### Signal:Once()
	743.1000012729783 µs (5000 call total)

	#### Signal:Wait()
	1102.1999998774845 µs (5000 call total)

	#### Signal:Fire()
	| Connection Count | Time (200 call average) |
	| --- | --- |
	| 0 connections | 0.04200001058052294 µs |
	| 1 connections | 0.1650000012887176 µs |
	| 100 connections | 13.564500004576985 µs |
	| 1000 connections | 115.78499999814085 µs |
	| 5000 connections | 555.1089999971737 µs |

	#### Signal:Disconnect()
	| Connection Count | Time (5000 disconnects) |
	| --- | --- |
	| 5000 to 0 connections | 335.5000008014031 µs |
	| 11000 to 6000 connections | 335.40000003995374 µs |
	| 15000 to 10000 connections | 288.69999732705764 µs |

	#### Signal:DisconnectAll()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.13480005145538598 µs |
	| 100 connections | 1.0327999843866564 µs |
	| 1000 connections | 9.549599977617618 µs |
	| 5000 connections | 50.3668000237667 µs |

	#### Signal:Destroy()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.15800003166077659 µs |
	| 100 connections | 1.165799971204251 µs |
	| 1000 connections | 9.813200049393345 µs |
	| 5000 connections | 50.63779999181861 µs |

=== "GoodSignal"

	### SignalPlus (Immediate)
	#### Signal.new()
	267.50000006359187 µs (10000 call total)

	#### Signal:Connect()
	399.8999999339503 µs (5000 call total)

	#### Signal:Once()
	545.6999999751133 µs (5000 call total)

	#### Signal:Wait()
	1135.2999999871827 µs (5000 call total)

	#### Signal:Fire()
	| Connection Count | Time (200 call average) |
	| --- | --- |
	| 0 connections | 0.03900000024259498 µs |
	| 1 connections | 0.5060000000867149 µs |
	| 100 connections | 43.24550000035288 µs |
	| 1000 connections | 435.5209999999943 µs |
	| 5000 connections | 2175.2580000003263 µs |

	#### Signal:Disconnect()
	| Connection Count | Time (5000 disconnects) |
	| --- | --- |
	| 5000 to 0 connections | 239.09999993065867 µs |
	| 11000 to 6000 connections | 231.9999999826905 µs |
	| 15000 to 10000 connections | 249.10000001909793 µs |

	#### Signal:DisconnectAll()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.0786000011885335 µs |
	| 100 connections | 1.9902000010461052 µs |
	| 1000 connections | 19.697599998607984 µs |
	| 5000 connections | 97.33379999988756 µs |

	#### Signal:Destroy()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.16439999990325305 µs |
	| 100 connections | 2.0638000007693336 µs |
	| 1000 connections | 19.38200000040524 µs |
	| 5000 connections | 97.86559999770361 µs |

=== "LemonSignal"

	### LemonSignal
	#### Signal.new()
	389.7999999935564 µs (10000 call total)

	#### Signal:Connect()
	419.899999997142 µs (5000 call total)

	#### Signal:Once()
	652.500000001055 µs (5000 call total)

	#### Signal:Wait()
	1042.1999999152831 µs (5000 call total)

	#### Signal:Fire()
	| Connection Count | Time (200 call average) |
	| --- | --- |
	| 0 connections | 0.04850000038914004 µs |
	| 1 connections | 0.9205000003476016 µs |
	| 100 connections | 65.96199999989949 µs |
	| 1000 connections | 450.2524999998059 µs |
	| 5000 connections | 2268.1345000000874 µs |

	#### Signal:Disconnect()
	| Connection Count | Time (5000 disconnects) |
	| --- | --- |
	| 5000 to 0 connections | 268.69999999235006 µs |
	| 11000 to 6000 connections | 266.90000004236936 µs |
	| 15000 to 10000 connections | 280.5999999964115 µs |

	#### Signal:DisconnectAll()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.053200000593278673 µs |
	| 100 connections | 2.9320000053303374 µs |
	| 1000 connections | 28.414600002179213 µs |
	| 5000 connections | 143.57219999988047 µs |

	#### Signal:Destroy()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.06599999983336602 µs |
	| 100 connections | 2.9831999956968502 µs |
	| 1000 connections | 28.356799998846327 µs |
	| 5000 connections | 150.04960000442225 µs |

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