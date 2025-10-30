
# OPC UA Browser – macOS

## Uso
1) Scarica questa cartella `macos` e apri il Terminale su questa cartella.
2) La prima volta esegui: `chmod +x setup_and_run.sh`.
3) Avvia: `./setup_and_run.sh`.
4) Se Python non è presente, lo script installerà Homebrew e poi python3.
5) Inserisci l’IP del PLC quando richiesto. Porta predefinita 4840.
6) Output a schermo e in `browse_log.txt`.

## Requisiti di rete
- Mac nella stessa rete del PLC.
- Firewall che consenta traffico verso IP_PLC:4840.
