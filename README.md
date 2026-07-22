# odoo-deploy
Despliegue productivo de Odoo 18 CE y Odoo 19 CE en Docker Compose.

## Repositorios
- `odoo-addons`: https://github.com/marcelompz/odoo-addons.git
  - `18.0`: addons custom + Enterprise v18 + l10n_py v18
  - `19.0`: addons custom + l10n_py v19
- `odoo-deploy`: https://github.com/marcelompz/odoo-deploy.git (este repo)
  - `v18`: docker-compose, configs, scripts y migración para Odoo 18 CE
  - `v19`: docker-compose, configs, scripts y migración para Odoo 19 CE

## Ruta productiva
- Addons v18: `/srv/odoo/addons/18.0` y `/srv/odoo/addons/l10n_py/v18`
- Addons v19: `/srv/odoo/addons/19.0` y `/srv/odoo/addons/l10n_py/v19`
- Local: `/opt/odoo`

## Estructura
```
docker-compose/
├── 18/
│   ├── odoo8085/
│   ├── odoo9038/
│   ├── odoo9043/
│   └── odoo9090/
└── 19/
    ├── odoo8083/
    └── odoo8084/
scripts/
```

Cada instancia incluye:
- `docker-compose.yml`
- `.env.example`
- `Dockerfile`
- `config/odoo.conf`
- `init_prod_db.sh`
- `modules.conf`
- `deploy.sh` (v19)
- `migracion/` (v18 y v19 donde aplique)

## Prerequisitos
```bash
# 1) Crear directorio productivo
sudo mkdir -p /srv/odoo/addons
sudo chown -R marcelompz:marcelompz /srv/odoo/addons

# 2) Clonar addons por versión
git clone --branch 18.0 --depth 1 git@github.com:marcelompz/odoo-addons.git /srv/odoo/addons/18.0
git clone --branch 19.0 --depth 1 git@github.com:marcelompz/odoo-addons.git /srv/odoo/addons/19.0

# 3) Clonar despliegue
git clone --branch v18 --depth 1 git@github.com:marcelompz/odoo-deploy.git /srv/odoo-deploy-v18
git clone --branch v19 --depth 1 git@github.com:marcelompz/odoo-deploy.git /srv/odoo-deploy-v19
```

## Deploy por instancia (v19)
```bash
cd /srv/odoo-deploy-v19/docker-compose/19/odoo8084
cp .env.example .env
# Editar credenciales en .env
./deploy.sh
```

O manual:
```bash
cd /srv/odoo-deploy-v19/docker-compose/19/odoo8084
docker compose up -d db
docker compose build web
docker compose up -d init
docker compose up -d web
```

## Variables .env
- `WEB_ADDONS_CUSTOMIZE`: ruta a addons custom (default `/srv/odoo/addons/18.0` o `/srv/odoo/addons/19.0`)
- `WEB_ADDONS_L10NPY`: ruta a localización Paraguay (default `/srv/odoo/addons/l10n_py/v18` o `/srv/odoo/addons/l10n_py/v19`)
- `DB_VOLUMES`, `WEB_VOLUMES`: rutas de datos persistentes

## Inicialización
`init_prod_db.sh`:
- Crea DB si no existe
- Instala módulos de `modules.conf`
- Parche en caliente `electronic_invoice_cross`
- Configura Paraguay (país, moneda PYG)
- Establece password admin
- Importa datos de `migracion/` (empresa, usuarios, productos, recetas)

## Migración de datos
`migracion/` incluye:
- `import_products_direct.py`
- `import_comidas_direct.py`
- `import_recipes_direct.py`
- `import_company_users.py`
- `import_settings.py`
- CSVs y excels de productos/materias primas/recetas

Activar con variable de entorno `IMPORT_PRODUCTS=true` o `IMPORT_RECIPES=true`.
