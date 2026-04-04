@echo off
REM ─────────────────────────────────────────────────────────────────────────────
REM run.bat – Spustenie Gaussian Splatting kontajnera na Windows
REM
REM Požiadavky:
REM   - Docker Desktop s WSL2 backendom
REM   - NVIDIA GPU + ovládače s WSL2 podporou
REM   - Windows 11 (WSLg) alebo VcXsrv/Xming pre GUI (Windows 10)
REM ─────────────────────────────────────────────────────────────────────────────

echo === Gaussian Splatting Docker ===
echo.

REM Skontroluj Docker
docker version >nul 2>&1
if errorlevel 1 (
    echo CHYBA: Docker nie je spusteny alebo nainstalovany.
    echo  Nainštaluj Docker Desktop z https://www.docker.com/products/docker-desktop/
    echo  a zapni WSL2 backend v nastaveniach.
    pause
    exit /b 1
)

REM Build ak image ešte neexistuje
docker image inspect gaussian-splatting:latest >nul 2>&1
if errorlevel 1 (
    echo Image neexistuje. Builduje sa (30-60 min)...
    docker compose build
    if errorlevel 1 (
        echo CHYBA pri builde!
        pause
        exit /b 1
    )
)

REM Spusti kontajner
REM  - Na Windows 11 s WSLg funguje DISPLAY automaticky cez WSL2
REM  - Na Windows 10 treba spusteného VcXsrv a nastaviť DISPLAY=host.docker.internal:0
echo Spúšťam kontajner...
echo.
echo  Pre GUI (COLMAP, SIBR viewer):
echo    Windows 11: funguje automaticky cez WSLg
echo    Windows 10: nainštaluj VcXsrv a spusti ho pred týmto skriptom
echo.

docker compose run --rm -e DISPLAY=host.docker.internal:0 gaussian-splatting

pause
