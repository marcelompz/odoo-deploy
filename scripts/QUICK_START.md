#  Odoo Implementation Automation - Quick Start Guide

##  Ubicación

**Directorio principal:** `/opt/odoo/scripts/`

---

##  Scripts Principales

### **1. Para Demo Rápida de Cliente Nuevo**

```bash
# Crear script template para cliente
/opt/odoo/scripts/create_client_demo.sh "Nombre Cliente" "Industria"

# Ejemplo:
/opt/odoo/scripts/create_client_demo.sh "Mi Empresa S.A." "Tecnología"
```

**Qué hace:**
- ✅ Crea script Python personalizado para el cliente
- ✅ Incluye 2 vendedores con usuarios
- ✅ Crea cliente principal
- ✅ Crea 3 productos característicos
- ✅ Genera 2 oportunidades CRM
- ✅ Crea pedido de venta confirmado

**Próximos pasos:**
1. Editar el script generado con datos reales
2. Ejecutar: `docker exec -i odoo_web_8084 odoo shell -d demo_cliente < seed_nombre_cliente_demo.py`

---

### **2. Para Demo AGRIPAR (Ya Creada)**

```bash
# Ejecutar seed completo con verificaciones
/opt/odoo/scripts/run_agripar_seed_simple.sh
```

**Qué hace:**
- ✅ Verifica que Odoo esté disponible
- ✅ Verifica módulos instalados
- ✅ Instala automáticamente módulos faltantes
- ✅ Crea 3 vendedores con usuarios
- ✅ Crea datos de demo hidráulicos
- ✅ Muestra resumen completo

**Acceso a la demo:**
- URL: `http://localhost:8084`
- Admin: `admin` / `admin`
- Vendedores: `carlos`, `maria`, `jorge` (password: `agripar123`)

---

### **3. Para Reiniciar desde Cero**

```bash
/opt/odoo/scripts/force_init_odoo.sh
```

**Qué hace:**
- ⚠️ **Elimina toda la base de datos**
- ✅ Limpia volúmenes Docker
- ✅ Reinicializa Odoo con módulos base
- ✅ Deja DB lista para nuevo seed

**Cuándo usar:**
- DB corrupta
- Quieres empezar limpio para demo
- Después de probar configuraciones

---

##  Estructura Completa

```
/opt/odoo/scripts/
├── README.md                          # Documentación completa
├── QUICK_START.md                     # Esta guía
├── create_client_demo.sh              # Template para nuevos clientes
├── force_init_odoo.sh                 # Reinicialización completa
├── run_agripar_seed_simple.sh         # Demo AGRIPAR (auto-install)
├── run_agripar_seed.sh                # Demo AGRIPAR (con verificaciones)
├── seed_agripar_demo.py               # Script principal AGRIPAR
└── README_AGRIPAR_DEMO.md             # Doc específica AGRIPAR
```

---

## 🎯 Flujo de Trabajo Típico

### **Para Nuevo Cliente:**

```bash
# 1. Crear template
/opt/odoo/scripts/create_client_demo.sh "Cliente XYZ" "Rubro"

# 2. Editar script (datos reales del cliente)
nano /opt/odoo/scripts/seed_cliente_xyz_demo.py

# 3. Asegurar DB limpia (opcional)
/opt/odoo/scripts/force_init_odoo.sh

# 4. Ejecutar seed
docker exec -i odoo_web_8084 odoo shell -d cliente_xyz < seed_cliente_xyz_demo.py

# 5. Verificar en navegador
# http://localhost:8084
```

### **Para Demo AGRIPAR (Re-ejecutar):**

```bash
# Simplemente ejecutar
/opt/odoo/scripts/run_agripar_seed_simple.sh
```

---

## 🔐 Credenciales por Defecto

| Usuario | Login | Password |
|---------|-------|----------|
| Admin | `admin` | `admin` |
| Vendedor 1 (AGRIPAR) | `carlos` | `agripar123` |
| Vendedor 2 (AGRIPAR) | `maria` | `agripar123` |
| Vendedor 3 (AGRIPAR) | `jorge` | `agripar123` |
| Vendedor 1 (Template) | `vendedor1` | `cliente123` |
| Vendedor 2 (Template) | `vendedor2` | `cliente123` |

---

##  Módulos que se Instalan Automáticamente

El script `run_agripar_seed_simple.sh` verifica e instala:

| Módulo | Nombre Técnico | Propósito |
|--------|---------------|-----------|
| Base | `base` | Núcleo de Odoo |
| Web | `web` | Interfaz web |
| CRM | `crm` | Gestión de oportunidades |
| Ventas | `sale_management` | Pedidos y presupuestos |
| Inventario | `stock` | Gestión de stock |
| Compras | `purchase` | Órdenes de compra |
| Empleados | `hr` | Recursos humanos |
| Paraguay | `l10n_py` | Contabilidad paraguaya |

---

## ️ Comandos Útiles

### **Verificar módulos instalados:**
```bash
docker exec db_odoo_5436 psql -U odoo -d ferreteria -c \
  "SELECT name, state FROM ir_module_module WHERE name IN ('crm', 'sale_management', 'stock', 'purchase', 'hr', 'l10n_py');"
```

### **Ver usuarios creados:**
```bash
docker exec db_odoo_5436 psql -U odoo -d ferreteria -c \
  "SELECT name, login, email FROM res_users WHERE login IN ('carlos', 'maria', 'jorge');"
```

### **Ver oportunidades CRM:**
```bash
docker exec db_odoo_5436 psql -U odoo -d ferreteria -c \
  "SELECT name, expected_revenue, probability FROM crm_lead WHERE type = 'opportunity';"
```

### **Logs de Odoo en tiempo real:**
```bash
docker logs -f odoo_web_8084
```

---

## ️ Advertencias Importantes

1. **NO usar en producción** sin testing previo
2. **Siempre hacer backup** antes de ejecutar scripts
3. **Los scripts eliminan datos** existentes con el mismo nombre
4. **Verificar permisos** de usuarios después de crearlos
5. **Cambiar contraseñas** por defecto en demos reales

---

## 📞 Soporte

**Contacto:** +595 972 310933  
**Email:** admin@crossnexion.com  
**Ubicación:** Av. Amado Benítez c/ Los Girasoles, CDE

---

**Última actualización:** 26 de junio, 2026  
**Versión:** 1.0
