# odoo-deploy
Despliegue productivo de Odoo 18 CE y Odoo 19 CE en Docker.

## Estructura
- `docker-compose/v18/` instancias productivas v18
- `docker-compose/v19/` instancias productivas v19
- `scripts/` utilidades de deploy y operación
- Cada instancia incluye `docker-compose.yml`, `.env.example`, `init_prod_db.sh`, `modules.conf`, `Dockerfile`, `config/` y `migracion/` si aplica.

## Addons
Las rutas de addons apuntan a `/srv/odoo/addons`:
- v18: `/srv/odoo/addons/18.0` y `/srv/odoo/addons/l10n_py/v18`
- v19: `/srv/odoo/addons/19.0` y `/srv/odoo/addons/l10n_py/v19`

Clona previamente las ramas correspondientes de `marcelompz/odoo-addons`:
```bash
git clone --branch 18.0 --depth 1 git@github.com:marcelompz/odoo-addons.git /srv/odoo/addons/18.0
git clone --branch 19.0 --depth 1 git@github.com:marcelompz/odoo-addons.git /srv/odoo/addons/19.0
```

## Deploy por instancia
```bash
cd docker-compose/v18/odoo8085
cp .env.example .env
docker compose up -d
docker compose exec web9049 bash /init_prod_db.sh
```
