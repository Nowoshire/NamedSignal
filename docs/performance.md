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
	358.9999978430569 µs (10000 call total)

	#### Signal:Connect()
	723.5999801196158 µs (5000 call total)

	#### Signal:Fire()
	| Connection Count | Time (200 call average) |
	| --- | --- |
	| 0 connections | 0.03850000211969018 µs |
	| 1 connections | 0.15300000086426735 µs |
	| 100 connections | 12.558999878820032 µs |
	| 1000 connections | 112.05450020497665 µs |
	| 5000 connections | 554.5504999463446 µs |

	#### Signal:Disconnect()
	| Connection Count | Time (5000 disconnects) |
	| --- | --- |
	| 5000 to 0 connections | 385.6000257655978 µs |
	| 11000 to 6000 connections | 336.60000190138817 µs |
	| 12000 to 7000 connections | 282.3999966494739 µs |

	#### Signal:DisconnectAll()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.11000002268701792 µs |
	| 100 connections | 2.287598676048219 µs |
	| 1000 connections | 19.89719911944121 µs |
	| 5000 connections | 98.53019961155951 µs |

	#### Signal:Destroy()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.1716000260785222 µs |
	| 100 connections | 2.2674002684652805 µs |
	| 1000 connections | 20.06679878104478 µs |
	| 5000 connections | 99.25879840739071 µs |

=== "SignalPlus (Immediate)"

	### SignalPlus (Immediate)
	#### Signal.new()
	334.9999897181988 µs (10000 call total)

	#### Signal:Connect()
	410.99998634308577 µs (5000 call total)

	#### Signal:Fire()
	| Connection Count | Time (200 call average) |
	| --- | --- |
	| 0 connections | 0.04050001734867692 µs |
	| 1 connections | 0.4934999742545187 µs |
	| 100 connections | 46.38300015358254 µs |
	| 1000 connections | 445.8919999888167 µs |
	| 5000 connections | 2220.0780001003295 µs |

	#### Signal:Disconnect()
	| Connection Count | Time (5000 disconnects) |
	| --- | --- |
	| 5000 to 0 connections | 240.40002608671784 µs |
	| 11000 to 6000 connections | 296.69998912140727 µs |
	| 12000 to 7000 connections | 224.5999639853835 µs |

	#### Signal:DisconnectAll()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.10179984383285046 µs |
	| 100 connections | 2.5961999781429768 µs |
	| 1000 connections | 20.182800013571978 µs |
	| 5000 connections | 96.78999846801162 µs |

	#### Signal:Destroy()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.1706002512946725 µs |
	| 100 connections | 2.358599565923214 µs |
	| 1000 connections | 20.18580201547593 µs |
	| 5000 connections | 99.8007986927405 µs |

=== "FastSignal (Immediate)"

	### FastSignal (Immediate)
	#### Signal.new()
	439.70003025606275 µs (10000 call total)

	#### Signal:Connect()
	644.0000142902136 µs (5000 call total)

	#### Signal:Fire()
	| Connection Count | Time (200 call average) |
	| --- | --- |
	| 0 connections | 0.05599984433501959 µs |
	| 1 connections | 0.5835000774823129 µs |
	| 100 connections | 47.94200009200722 µs |
	| 1000 connections | 437.03050003387034 µs |
	| 5000 connections | 2129.0395001415163 µs |

	#### Signal:Disconnect()
	| Connection Count | Time (5000 disconnects) |
	| --- | --- |
	| 5000 to 0 connections | 265.19998209550977 µs |
	| 11000 to 6000 connections | 265.69998590275645 µs |
	| 12000 to 7000 connections | 279.7000342980027 µs |

	#### Signal:DisconnectAll()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.11040049139410257 µs |
	| 100 connections | 1.7760001355782151 µs |
	| 1000 connections | 17.43039977736771 µs |
	| 5000 connections | 87.96260098461062 µs |

	#### Signal:Destroy()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.11560018174350262 µs |
	| 100 connections | 2.316999714821577 µs |
	| 1000 connections | 17.109600361436605 µs |
	| 5000 connections | 88.17880100104958 µs |

=== "GoodSignal"

	### GoodSignal
	#### Signal.new()
	729.8000273294747 µs (10000 call total)

	#### Signal:Connect()
	659.6000166609883 µs (5000 call total)

	#### Signal:Fire()
	| Connection Count | Time (200 call average) |
	| --- | --- |
	| 0 connections | 0.034999975468963385 µs |
	| 1 connections | 0.5669999518431723 µs |
	| 100 connections | 45.275499869603664 µs |
	| 1000 connections | 474.6544998488389 µs |
	| 5000 connections | 2477.3664999520406 µs |

	#### Signal:Disconnect()
	| Connection Count | Time (5000 disconnects) |
	| --- | --- |
	| 5000 to 0 connections | 131935.29995623976 µs |
	| 11000 to 6000 connections | 446185.39995281026 µs |
	| 12000 to 7000 connections | 183554.29999064654 µs |

	#### Signal:DisconnectAll()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| 0 connections | 0.05100003909319639 µs |
	| 100 connections | 0.0596002209931612 µs |
	| 1000 connections | 0.08340028580278158 µs |
	| 5000 connections | 0.1268003834411502 µs |

	#### Signal:Destroy()
	| Connection Count | Time (500 call average) |
	| --- | --- |
	| N/A: No Signal:Destroy() |