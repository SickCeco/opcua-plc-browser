
#!/usr/bin/env bash
set -euo pipefail

need_cmd() { command -v "$1" >/dev/null 2>&1; }

# 1) Installa Homebrew se manca, poi Python3 se manca
if ! need_cmd python3; then
  echo "Python3 non trovato. Verifico Homebrew..."
  if ! need_cmd brew; then
    echo "Homebrew non trovato. Installazione in corso..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile" || true
    eval "$(/opt/homebrew/bin/brew shellenv)" || true
  fi
  echo "Installo python3 via Homebrew..."
  brew update
  brew install python
fi

# 2) Crea venv se manca
if [ ! -d ".venv" ]; then
  python3 -m venv .venv
fi
# shellcheck disable=SC1091
source .venv/bin/activate

# 3) Installa dipendenze e avvia
python -m pip install --upgrade pip
pip install -r requirements.txt

read -r -p "Inserisci l'IP del PLC: " PLCIP
if [ -z "$PLCIP" ]; then
  echo "IP non valido" >&2
  exit 2
fi

python main.py --ip "$PLCIP"
