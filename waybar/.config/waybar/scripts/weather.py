#!/usr/bin/env python3
import sys
import os
import json
import time
import urllib.request
from datetime import datetime

CACHE_FILE = f"/tmp/waybar-weather-cache-{os.getuid()}.json"
CACHE_EXPIRY = 900  # 15 minutos

WEATHER_MAP = {
    "113": ("Céu limpo", "󰖙"),
    "116": ("Parcialmente nublado", "󰖕"),
    "119": ("Nublado", "󰖐"),
    "122": ("Encoberto", "󰖐"),
    "143": ("Névoa", "󰖑"),
    "176": ("Chuva fraca isolada", "󰖖"),
    "179": ("Neve fraca", "󰖘"),
    "182": ("Granizo leve", "󰖒"),
    "185": ("Garoa congelante", "󰖒"),
    "200": ("Trovoadas isoladas", "󰙾"),
    "227": ("Neve com vento", "󰖘"),
    "230": ("Nevasca", "󰖘"),
    "248": ("Nevoeiro", "󰖑"),
    "260": ("Nevoeiro congelante", "󰖑"),
    "263": ("Garoa leve", "󰖖"),
    "266": ("Garoa", "󰖖"),
    "281": ("Garoa congelante", "󰖒"),
    "284": ("Garoa forte", "󰖒"),
    "293": ("Chuva leve", "󰖖"),
    "296": ("Chuva leve", "󰖖"),
    "299": ("Chuva moderada", "󰖖"),
    "302": ("Chuva moderada", "󰖖"),
    "305": ("Chuva forte", "󰖖"),
    "308": ("Chuva torrencial", "󰖖"),
    "311": ("Chuva gelada", "󰖒"),
    "314": ("Chuva congelante", "󰖒"),
    "317": ("Granizo", "󰖒"),
    "320": ("Chuva com granizo", "󰖒"),
    "323": ("Neve leve", "󰖘"),
    "326": ("Neve moderada", "󰖘"),
    "329": ("Neve forte", "󰖘"),
    "332": ("Neve intensa", "󰖘"),
    "335": ("Tempestade de neve", "󰖘"),
    "338": ("Nevasca pesada", "󰖘"),
    "350": ("Granizo", "󰖒"),
    "353": ("Pancadas de chuva leve", "󰖖"),
    "356": ("Pancadas de chuva", "󰖖"),
    "359": ("Tempestade de chuva", "󰖖"),
    "362": ("Pancadas de granizo", "󰖒"),
    "365": ("Pancadas de granizo", "󰖒"),
    "368": ("Pancadas de neve", "󰖘"),
    "371": ("Pancadas de neve forte", "󰖘"),
    "374": ("Granizo", "󰖒"),
    "377": ("Granizo pesado", "󰖒"),
    "386": ("Chuva com trovoadas", "󰙾"),
    "389": ("Tempestade com raios", "󰙾"),
    "392": ("Neve com raios", "󰙾"),
    "395": ("Nevasca com trovões", "󰙾")
}

def get_cached():
    if os.path.exists(CACHE_FILE):
        try:
            with open(CACHE_FILE, "r") as f:
                data = json.load(f)
                if time.time() - data.get("timestamp", 0) < CACHE_EXPIRY:
                    return data.get("output")
        except Exception:
            pass
    return None

def save_cache(output):
    try:
        with open(CACHE_FILE, "w") as f:
            json.dump({"timestamp": time.time(), "output": output}, f)
    except Exception:
        pass

def fetch_weather():
    url = "https://wttr.in/?format=j1"
    req = urllib.request.Request(url, headers={"User-Agent": "curl/7.68.0"})
    with urllib.request.urlopen(req, timeout=5) as response:
        return json.loads(response.read().decode("utf-8"))

def main():
    force_refresh = len(sys.argv) > 1 and sys.argv[1] == "refresh"
    if not force_refresh:
        cached = get_cached()
        if cached:
            print(json.dumps(cached))
            return

    try:
        data = fetch_weather()
        curr = data["current_condition"][0]
        area = data.get("nearest_area", [{}])[0]
        forecast = data.get("weather", [{}])[0]

        city = area.get("areaName", [{}])[0].get("value", "")
        region = area.get("region", [{}])[0].get("value", "")
        loc_str = f"{city}, {region}".strip(", ") if city else "Clima Atual"

        code = curr.get("weatherCode", "119")
        temp = curr.get("temp_C", "--")
        feels_like = curr.get("FeelsLikeC", temp)
        humidity = curr.get("humidity", "--")
        wind = curr.get("windspeedKmph", "--")

        min_temp = forecast.get("mintempC", "--")
        max_temp = forecast.get("maxtempC", "--")

        desc, icon = WEATHER_MAP.get(code, ("Nublado", "󰖐"))

        # Ícone de noite se céu limpo/parcial
        hour = datetime.now().hour
        is_night = hour < 6 or hour >= 19
        if is_night:
            if code == "113":
                icon = "󰖔"
            elif code == "116":
                icon = "󰼱"

        text = f"{icon}  {temp}°C"
        tooltip = (
            f"<b>{loc_str}</b>\n"
            f"{icon}  {desc}\n\n"
            f"• <b>Sensação:</b> {feels_like}°C\n"
            f"• <b>Mín / Máx:</b> {min_temp}°C / {max_temp}°C\n"
            f"• <b>Umidade:</b> {humidity}%\n"
            f"• <b>Vento:</b> {wind} km/h\n\n"
            f"<i>Clique para atualizar</i>"
        )

        output = {"text": text, "tooltip": tooltip, "class": "weather"}
        save_cache(output)
        print(json.dumps(output))

    except Exception:
        # Tenta usar cache antigo se requisição falhar
        if os.path.exists(CACHE_FILE):
            try:
                with open(CACHE_FILE, "r") as f:
                    old = json.load(f).get("output")
                    if old:
                        print(json.dumps(old))
                        return
            except Exception:
                pass
        # Fallback padrão
        print(json.dumps({"text": "󰖐  --°C", "tooltip": "Sem conexão para clima\n<i>Clique para tentar atualizar</i>", "class": "offline"}))

if __name__ == "__main__":
    main()
