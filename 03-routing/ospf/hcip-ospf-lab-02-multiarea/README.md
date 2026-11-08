# HCIP OSPF Lab 2: Multi-Area OSPF

A multi-area OSPF lab built in Huawei eNSP using five AR routers and one switch. It covers area design, ABRs, an ASBR injecting a default route, route redistribution, and inter-area route summarization.

## Objectives

- Configure OSPF across three areas (Area 0, Area 1, Area 2)
- Understand ABR behaviour (Type 3 Summary LSAs) and ASBR behaviour (Type 5 External LSAs)
- Inject a default route into OSPF from an ASBR
- Redistribute routes into OSPF and observe Type 1 vs Type 2 external metrics
- Verify adjacencies, the LSDB and routing tables on every router

## Topology

![OSPF Lab 2 Topology](topology/OSPF%20LAB%202%20TOPOLOGY.png)

| Router | Router ID | Role | Area(s) |
|--------|-----------|------|---------|
| AR1 | 10.0.1.1 | Internal router / ASBR (originates default route) | 2 (0.0.0.2) |
| AR2 | 10.0.2.2 | ABR + redistributes external routes | 0 and 2 |
| AR3 | 10.0.3.3 | Internal router | 2 (0.0.0.2) |
| AR4 | 10.0.4.4 | ABR | 0 and 1 |
| AR5 | 10.0.5.5 | Internal router | 1 (0.0.0.1) |

## Links and addressing

| Segment | Subnet | Devices | Area |
|---------|--------|---------|------|
| AR1 / AR2 / AR3 via switch | 10.0.123.0/24 | AR1 .1, AR2 .2 (DR), AR3 .3 | 2 |
| AR2 GE0/0/1 to AR4 GE0/0/0 | 10.0.24.0/24 | AR2 .2, AR4 .4 | 0 |
| AR4 GE0/0/1 to AR5 GE0/0/0 | 10.0.45.0/24 | AR4 .4, AR5 .5 | 1 |

Loopback networks (advertised with their /24 masks using `ospf network-type broadcast`):

| Router | Networks |
|--------|----------|
| AR1 | 10.0.1.0/24 |
| AR2 | 10.0.2.0/24 |
| AR3 | 10.0.3.0/24, 10.3.0.0/24, 10.3.1.0/24 |
| AR4 | 10.0.4.0/24 |
| AR5 | 10.0.5.0/24, 10.5.0.0/24, 10.5.1.0/24 |

## OSPF design

- **Area 0 (backbone):** AR2 and AR4 over 10.0.24.0/24
- **Area 1:** AR4 and AR5 over 10.0.45.0/24
- **Area 2:** AR1, AR2 and AR3 over 10.0.123.0/24
- **Default route:** AR1 originates `0.0.0.0/0` as a Type 1 external route (tag 1)
- **Redistribution:** AR2 injects external routes (10.0.2.0, 10.2.0.0, 10.0.123.0 and 10.0.24.0) into OSPF
- **Summarization:** the routing tables show 10.3.0.0/23 and 10.5.0.0/23 as single inter-area routes in other areas, so the ABRs are summarizing the 10.3.x.x and 10.5.x.x loopback pairs

## Expected results

All adjacencies reach **Full** state:

| Router | Neighbors |
|--------|-----------|
| AR2 | AR4 (Area 0), AR1 and AR3 (Area 2) |
| AR3 | AR1 and AR2 (Area 2) |
| AR4 | AR2 (Area 0), AR5 (Area 1) |
| AR5 | AR4 (Area 1) |

Routing table summary (from the verification outputs):

| Router | Total | Intra-area | Inter-area | ASE |
|--------|-------|-----------|------------|-----|
| AR2 | 12 | 8 | 3 | 1 |
| AR3 | 13 | 5 | 6 | 2 |
| AR4 | 13 | 7 | 4 | 2 |
| AR5 | 13 | 4 | 7 | 2 |

Default route cost seen from each router (Type 1 accumulates link cost): AR2 = 11, AR4 = 21, AR5 = 31.

## Repository structure

```
hcip-ospf-lab-02-multiarea/
├── HCIP_OSPF LAB 2 MULT_AREA.topo   # eNSP topology file
├── configs/                         # Device configurations (R1.cfg to R5.cfg)
├── topology/                        # Topology diagram
└── verification/                    # display ospf peer / lsdb / routing outputs
```

## How to run the lab

1. Install Huawei **eNSP** (with VirtualBox).
2. Open `HCIP_OSPF LAB 2 MULT_AREA.topo` in eNSP.
3. Start all devices.
4. Load each router's configuration from `configs/`, either by pasting it into the CLI or by right-clicking the device and choosing **Import Device Configuration**.
5. Wait about 30 to 60 seconds for adjacencies to form.

## Verification commands

```
display ospf peer brief
display ospf lsdb
display ospf routing
display ip routing-table protocol ospf
```

Saved outputs for each router are in the `verification/` folder.

## Key takeaways

- ABRs (AR2, AR4) generate Type 3 Summary LSAs between areas
- Routers in other areas reach the ASBR through Type 4 Summary-ASBR LSAs
- Type 1 external metrics include the internal cost to the ASBR, while Type 2 metrics stay fixed across the domain (10.2.0.0/23 shows cost 2 on every router)
- Loopbacks default to /32 on Huawei devices unless the OSPF network type is set to broadcast

## Environment

- Huawei eNSP
- Router model: AR (e.g. AR1220)
- Switch model: S3700 (or similar)

## Author

Your name · [GitHub profile](https://github.com/your-username)
