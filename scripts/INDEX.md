# 📚 Odoo Implementation Scripts - Index

Bienvenido al sistema de automatización de implementaciones de Odoo de Crossnexion.

---

## 🚀 Inicio Rápido

**¿Primera vez aquí?** → Lee [`QUICK_START.md`](QUICK_START.md)

**¿Necesitas crear una demo para un cliente nuevo?** → Ejecuta:
```bash
/opt/odoo/scripts/create_client_demo.sh "Nombre Cliente" "Industria"
```

**¿Quieres re-ejecutar la demo de AGRIPAR?** → Ejecuta:
```bash
/opt/odoo/scripts/run_agripar_seed_simple.sh
```

**¿Necesitas reiniciar la base de datos?** → Ejecuta:
```bash
/opt/odoo/scripts/force_init_odoo.sh
```

---

## 📖 Documentación Disponible

| Documento | Propósito | Cuándo Leer |
|-----------|-----------|-------------|
| [`QUICK_START.md`](QUICK_START.md) | Guía de inicio rápido | Primera vez, necesidades urgentes |
| [`README.md`](README.md) | Documentación completa y templates | Implementación detallada |
| [`README_AGRIPAR_DEMO.md`](README_AGRIPAR_DEMO.md) | Demo específica de AGRIPAR | Presentación a AGRIPAR |

---

## 🎯 Scripts Disponibles

### **Automatización de Clientes**

| Script | Descripción | Uso |
|--------|-------------|-----|
| `create_client_demo.sh` | Crea template para cliente nuevo | `/opt/odoo/scripts/create_client_demo.sh "Cliente" "Rubro"` |
| `seed_[cliente]_demo.py` | Script Python con datos del cliente | Auto-generado por `create_client_demo.sh` |

### **Demo AGRIPAR**

| Script | Descripción | Uso |
|--------|-------------|-----|
| `run_agripar_seed_simple.sh` | Seed automático con verificaciones | `/opt/odoo/scripts/run_agripar_seed_simple.sh` |
| `run_agripar_seed.sh` | Seed con verificaciones extendidas | `/opt/odoo/scripts/run_agripar_seed.sh` |
| `seed_agripar_demo.py` | Script principal de AGRIPAR | Ejecutado automáticamente por los wrappers |

### **Mantenimiento**

| Script | Descripción | Uso |
|--------|-------------|-----|
| `force_init_odoo.sh` | Reinicializa DB desde cero | `/opt/odoo/scripts/force_init_odoo.sh` |

---

##  Estructura de Archivos

```
/opt/odoo/scripts/
│
├── INDEX.md                         # Este archivo (índice)
├── QUICK_START.md                   # Guía rápida de inicio ⭐
├── README.md                        # Documentación completa
├── README_AGRIPAR_DEMO.md           # Demo AGRIPAR específica
│
├── create_client_demo.sh            # Template para nuevos clientes
── force_init_odoo.sh               # Reinicialización de DB
├── run_agripar_seed_simple.sh       # Demo AGRIPAR (auto)
├── run_agripar_seed.sh              # Demo AGRIPAR (extendido)
├── seed_agripar_demo.py             # Script AGRIPAR principal
│
└── [otros scripts de diagnóstico]   # Scripts de debugging varios
```

---

## 🎬 Flujos de Trabajo

### **Flujo 1: Nuevo Cliente (5 minutos)**

```bash
# Paso 1: Crear template
cd /opt/odoo/scripts
./create_client_demo.sh "Mi Cliente S.A." "Distribución"

# Paso 2: Editar datos del cliente
nano seed_mi_cliente_demo.py
# Editar: nombre, RUC, productos, vendedores

# Paso 3: Ejecutar
docker exec -i odoo_web_8084 odoo shell -d mi_cliente < seed_mi_cliente_demo.py

# Paso 4: Verificar
# Abrir http://localhost:8084
```

---

### **Flujo 2: Demo AGRIPAR (2 minutos)**

```bash
# Ejecutar seed automático
/opt/odoo/scripts/run_agripar_seed_simple.sh

# Acceder a demo
# URL: http://localhost:8084
# Admin: admin/admin
# Vendedores: carlos, maria, jorge (agripar123)
```

---

### **Flujo 3: Limpieza Total (3 minutos)**

```bash
# Reiniciar desde cero
/opt/odoo/scripts/force_init_odoo.sh

# Luego ejecutar seed deseado
/opt/odoo/scripts/run_agripar_seed_simple.sh
```

---

## 🔍 Troubleshooting

| Problema | Solución | Documento |
|----------|----------|-----------|
| DB no inicializada | Ejecutar `force_init_odoo.sh` | [`QUICK_START.md`](QUICK_START.md) |
| Módulos faltantes | Script los instala automáticamente | [`README.md`](README.md) |
| Error en seed | Verificar logs: `docker logs -f odoo_web_8084` | [`README_AGRIPAR_DEMO.md`](README_AGRIPAR_DEMO.md) |
| Usuarios sin permisos | Configurar manualmente en Ajustes | [`README.md`](README.md) |

---

##  Contacto y Soporte

**Crossnexion EAS**  
📍 Av. Amado Benítez c/ Los Girasoles, Ciudad del Este  
📱 +595 972 310933  
📧 admin@crossnexion.com  

---

##  Recursos Adicionales

- [Documentación oficial Odoo 19](https://www.odoo.com/documentation/19.0/)
- [Odoo Shell Reference](https://www.odoo.com/documentation/19.0/developer/reference/backend/shell.html)
- [Odoo ORM Reference](https://www.odoo.com/documentation/19.0/developer/reference/backend/orm.html)

---

**Última actualización:** 26 de junio, 2026  
**Mantenido por:** Crossnexion EAS  
**Versión del índice:** 1.0
