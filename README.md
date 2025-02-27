# SyzDirect for AIxCC
Dieses Repository enthält den Directed Greybox Fuzzer SyzDirect https://github.com/seclab-fudan/SyzDirect, der für die Linux-Challenge der AIxCC https://github.com/aixcc-public/challenge-001-exemplar
angepasst wurde.

Die gesetzten Marker in SyzDirect für die AIxCC CVE-2021-43267 und den weiteren Verwundbarkeiten
CVE-2021-22600, CVE-2021-4154 und CVE-2022-0185 sind im Branch `Marker` enthalten. Dort sind
auch die für den AIxCC-Kernel angepassten KCov-Patches von SyzDirect.
Der Branch `SyzKaller` enthält Kernelconfig und SyzKaller-Config für den zu vergleichenden SyzKaller-Fuzzer

# Usage
Zuerst muss der geklonte Kernel der AIxCC-Linux-Challenge in SyzDirect vorbereitet werden: <br>
`python3 Main.py -linux-repo-template "path/to/challenge_kernel/challenge-
001-linux-source" prepare_for_manual_instrument`

Dann müssen im `Runner` Ordner die kcov_patches angewendet werden: <br>
`git apply kcov_h_manuell_patch.diff && git apply kcov_c_manuell_patch.diff`

Und es müssen alle Marker und CVEs vom Runner Ordner eingebaut werden. Für af_packet wäre das: <br>
`git apply af_packet.diff`

#### Dann wird der Kernel kompiliert:
`python3 Main.py prepare_kernel_bitcode -j $(nproc)`

#### Analysiert:
`python3 Main.py analyze_kernel_syscall -j $(nproc)`

Dieser Analyeschritt scheitert, weshalb in `Runner/workdir/multi-pts/case_0.txt`
folgendes eingefügt werden muss:
```
0 vfs_parse_fs_param_source
1 vfs_parse_fs_param
2 legacy_parse_param
```

#### Syscalls extrahiert:
`python3 Main.py extract_syscall_entry -j $(nproc)`

#### Instrumentiert:
`python3 Main.py instrument_kernel_with_distance -j $(nproc)`

#### Und der Fuzzer gestartet für 3000 Stunden und mit jeweils einer Instanz pro Marker xidx und mit 8 Threads:
`python3 Main.py fuzz -j 8 -fuzz-rounds 1 -uptime 3000`
