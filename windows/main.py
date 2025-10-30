
import argparse
import sys
from datetime import datetime
from opcua import Client

def parse_args():
    p = argparse.ArgumentParser(description="OPC UA namespace dump + objects tree browse")
    p.add_argument("--ip", type=str, help="Indirizzo IP del PLC", default=None)
    p.add_argument("--port", type=int, help="Porta OPC UA", default=4840)
    p.add_argument("--timeout", type=int, help="Timeout connessione (s)", default=5)
    p.add_argument("--max-depth", type=int, help="Profondità max ricorsione", default=6)
    p.add_argument("--max-children", type=int, help="Figli max per nodo", default=200)
    return p.parse_args()

def log_print(fh, msg):
    print(msg)
    try:
        fh.write(msg + "\n")
        fh.flush()
    except Exception:
        pass

def browse_tree(node, fh, depth, max_depth, max_children):
    if depth > max_depth:
        return
    try:
        children = node.get_children()
    except Exception as e:
        log_print(fh, "  " * depth + f"Errore get_children: {e}")
        return
    if not children:
        return
    children = children[:max_children]
    for child in children:
        try:
            name = child.get_browse_name().Name
        except Exception:
            name = "?"
        try:
            nid = child.nodeid.to_string()
        except Exception:
            nid = "?"
        log_print(fh, "  " * depth + f"- {name} ({nid})")
        browse_tree(child, fh, depth + 1, max_depth, max_children)

def main():
    args = parse_args()

    ip = args.ip or input("Inserisci l'IP del PLC: ").strip()
    if not ip:
        print("IP non valido")
        sys.exit(2)

    url = f"opc.tcp://{ip}:{args.port}"

    with open("browse_log.txt", "a", encoding="utf-8") as fh:
        log_print(fh, f"\n===== Avvio {datetime.now().isoformat(timespec='seconds')} URL={url} =====")

        client = Client(url)
        try:
            client.session_timeout = args.timeout * 1000
        except Exception:
            pass

        try:
            client.connect()
            log_print(fh, "Connesso")
            try:
                ns_array = client.get_namespace_array()
                log_print(fh, "Namespace array:")
                for i, uri in enumerate(ns_array):
                    log_print(fh, f"  ns={i} -> {uri}")
            except Exception as e:
                log_print(fh, f"Errore lettura namespace: {e}")

            try:
                objects = client.get_objects_node()
                log_print(fh, "\nSfoglia albero nodi (prime ramificazioni):")
                browse_tree(objects, fh, depth=1, max_depth=args.max_depth, max_children=args.max_children)
            except Exception as e:
                log_print(fh, f"Errore browse: {e}")

        except Exception as e:
            log_print(fh, f"Connessione fallita: {e}")
            sys.exit(1)
        finally:
            try:
                client.disconnect()
                log_print(fh, "Disconnesso")
            except Exception:
                pass

if __name__ == "__main__":
    main()
