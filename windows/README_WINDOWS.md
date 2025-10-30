
# OPC UA Browser – Windows

## Uso
1) Scarica questa cartella `windows` e mettila in `C:\OPCUA_Browser`.
2) Fai doppio clic su `setup_and_run.bat`.
3) Se Python non è presente, lo script lo installerà con winget o dall'installer ufficiale.
4) Inserisci l’IP del PLC quando richiesto. Porta predefinita 4840.
5) Output a schermo e in `browse_log.txt`.

## Requisiti di rete
- PC nella stessa rete del PLC.
- Firewall che consenta traffico verso IP_PLC:4840.
