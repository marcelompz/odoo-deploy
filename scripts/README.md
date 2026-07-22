#  Odoo Implementation Automation Scripts

Colección de scripts para automatizar implementaciones de Odoo para clientes.

---

## 📁 Estructura del Directorio

```
/opt/odoo/scripts/
├── README.md                      # Este archivo
├── seed_agripar_demo.py           # Template: Demo Agripar (repuestos hidráulicos)
├── run_agripar_seed_simple.sh     # Wrapper bash para Agripar
├── force_init_odoo.sh             # Forzar inicialización de DB
├── README_AGRIPAR_DEMO.md         # Documentación específica de Agripar
└── [otros scripts...]             # Scripts específicos por cliente
```

---

## 🎯 Casos de Uso

### **1. Nueva Implementación para Cliente**

Para crear una demo rápida para un nuevo cliente:

```bash
# 1. Copiar template de Agripar como base
cd /opt/odoo/scripts
cp seed_agripar_demo.py seed_[cliente]_demo.py

# 2. Editar el script con datos del cliente
#    - Nombre del cliente
#    - RUC
#    - Productos característicos
#    - Vendedores

# 3. Ejecutar el script
docker exec -i odoo_web_8084 odoo shell -d [database] < seed_[cliente]_demo.py
```

### **2. Re-inicializar Demo Existente**

```bash
cd /opt/odoo/scripts
./force_init_odoo.sh
```

### **3. Ejecutar Seed Específico**

```bash
cd /opt/odoo/scripts
./run_agripar_seed_simple.sh
```

---

## 📋 Scripts Disponibles

### **`seed_agripar_demo.py`**
**Propósito:** Crear datos de demo para AGRIPAR S.A. (distribuidora de repuestos hidráulicos)

**Datos creados:**
- ✅ 3 empleados/vendedores con usuarios de Odoo
- ✅ Cliente: Agripar - Estancia El Ombú
- ✅ Proveedor: Parker Hannifin Paraguay S.A.
- ✅ 4 productos hidráulicos con trazabilidad (lotes/series)
- ✅ Stock inicial con lotes
- ✅ 3 oportunidades CRM asignadas por vendedor
- ✅ Pedido de venta confirmado
- ✅ Solicitud de compra

**Módulos requeridos:**
- `crm`, `sale_management`, `stock`, `purchase`, `hr`, `l10n_py`

**Ejecución:**
```bash
/opt/odoo/scripts/run_agripar_seed_simple.sh
```

---

### **`force_init_odoo.sh`**
**Propósito:** Forzar inicialización de base de datos Odoo desde cero

**Cuándo usar:**
- DB corrupta o en estado inconsistente
- Necesitas limpiar todo y empezar de nuevo
- Pre-demo para asegurar que está limpio

**Ejecución:**
```bash
/opt/odoo/scripts/force_init_odoo.sh
```

**Advertencia:** ⚠️ Este script **elimina todos los datos** de la base de datos.

---

### **`run_agripar_seed_simple.sh`**
**Propósito:** Wrapper bash para ejecutar seed de Agripar con verificaciones automáticas

**Verificaciones:**
- ✅ Odoo está disponible
- ✅ Base de datos tiene tablas inicializadas
- ✅ Módulos requeridos están instalados
- ✅ Instala automáticamente módulos faltantes (`l10n_py`, `hr`, etc.)

**Ejecución:**
```bash
/opt/odoo/scripts/run_agripar_seed_simple.sh
```

---

##  Template para Nuevo Cliente

Para crear un script seed para un nuevo cliente, copia y edita:

```python
# -*- coding: utf-8 -*-
"""
Seed script para [NOMBRE CLIENTE]
Industria: [industria]
Fecha: [fecha]
"""
from datetime import datetime

# Modelos
partner_model = env['res.partner']
product_model = env['product.product']
lead_model = env['crm.lead']
sale_model = env['sale.order']
employee_model = env['hr.employee']
user_model = env['res.users']

print("🚀 Iniciando creación de datos para [CLIENTE]...")

# 1. Crear empleados/vendedores
vendedores_data = [
    {
        'name': 'Nombre Vendedor 1',
        'email': 'vendedor1@cliente.com',
        'login': 'vendedor1',
        'password': 'cliente123',
        'phone': '0981 234567',
        'job_title': 'Vendedor - Línea X',
    },
    # Agregar más vendedores...
]

for vendedor_data in vendedores_data:
    # Crear partner
    partner = partner_model.create({
        'name': vendedor_data['name'],
        'email': vendedor_data['email'],
        'phone': vendedor_data['phone'],
        'is_company': False,
    })
    
    # Crear empleado
    employee = employee_model.create({
        'name': vendedor_data['name'],
        'work_phone': vendedor_data['phone'],
        'work_email': vendedor_data['email'],
    })
    
    # Crear usuario
    user = user_model.create({
        'name': vendedor_data['name'],
        'login': vendedor_data['login'],
        'email': vendedor_data['email'],
        'password': vendedor_data['password'],
        'partner_id': partner.id,
        'employee_ids': [(6, 0, [employee.id])],
    })
    print(f"✅ Usuario creado: {vendedor_data['login']}")

# 2. Crear cliente principal
cliente = partner_model.create({
    'name': '[Nombre Cliente]',
    'vat': '80000000-0',  # RUC
    'email': 'info@cliente.com',
    'phone': '021 123456',
    'is_company': True,
})
print(f"✅ Cliente creado: {cliente.name}")

# 3. Crear productos característicos
productos_data = [
    {
        'name': 'Producto 1',
        'type': 'product',
        'list_price': 1000000,
        'standard_price': 600000,
        'categ_id': env.ref('product.product_category_all').id,
    },
    # Agregar más productos...
]

for prod_data in productos_data:
    product = product_model.create(prod_data)
    print(f"✅ Producto creado: {product.name}")

# 4. Crear oportunidades CRM
lead = lead_model.create({
    'name': 'Oportunidad Demo - [Cliente]',
    'partner_id': cliente.id,
    'expected_revenue': 5000000.0,
    'probability': 60.0,
    'user_id': user.id,  # Asignar a vendedor
})
print(f"✅ Oportunidad CRM creada: {lead.name}")

# 5. Crear pedido de venta
sale = sale_model.create({
    'partner_id': cliente.id,
    'user_id': user.id,
    'order_line': [(0, 0, {
        'product_id': product.id,
        'product_uom_qty': 10,
        'product_uom': product.uom_id.id,
    })],
})
sale.action_confirm()
print(f"✅ Pedido de venta creado: {sale.name}")

env.cr.commit()

print("\n" + "="*70)
print(f"🎉 ¡Datos de demo para [CLIENTE] creados exitosamente!")
print("="*70)
```

---

## 📞 Comandos Útiles

### **Verificar estado de módulos:**
```bash
docker exec db_odoo_5436 psql -U odoo -d ferreteria -c \
  "SELECT name, state FROM ir_module_module WHERE name IN ('crm', 'sale_management', 'stock', 'purchase', 'hr', 'l10n_py');"
```

### **Verificar usuarios creados:**
```bash
docker exec db_odoo_5436 psql -U odoo -d ferreteria -c \
  "SELECT name, login, email FROM res_users WHERE login IN ('carlos', 'maria', 'jorge');"
```

### **Verificar empleados:**
```bash
docker exec db_odoo_5436 psql -U odoo -d ferreteria -c \
  "SELECT name, work_phone, work_email FROM hr_employee;"
```

### **Verificar oportunidades CRM:**
```bash
docker exec db_odoo_5436 psql -U odoo -d ferreteria -c \
  "SELECT name, expected_revenue, probability, stage_id FROM crm_lead WHERE type = 'opportunity';"
```

---

## 🔐 Credenciales por Defecto

| Usuario | Login | Password | Perfiles |
|---------|-------|----------|----------|
| Administrador | `admin` | `admin` | Todos |
| Vendedor 1 | `carlos` | `agripar123` | Ventas/CRM |
| Vendedor 2 | `maria` | `agripar123` | Ventas/CRM |
| Vendedor 3 | `jorge` | `agripar123` | Ventas/CRM |

**Nota:** Para nuevos clientes, cambiar la contraseña base según políticas del cliente.

---

##  Mejores Prácticas

1. **Nunca ejecutar en producción** sin antes probar en ambiente de desarrollo
2. **Siempre hacer backup** de la base de datos antes de ejecutar scripts
3. **Verificar módulos instalados** antes de ejecutar seed
4. **Documentar datos creados** para cada cliente
5. **Mantener scripts versionados** en git

---

## 🚨 Solución de Problemas

### **Error: "relation does not exist"**
**Causa:** La base de datos no está inicializada
**Solución:** Ejecutar `force_init_odoo.sh` o inicializar desde el navegador

### **Error: "Invalid field 'groups_id'"**
**Causa:** Campo no existe en Odoo 19
**Solución:** No asignar grupos directamente, configurar manualmente después

### **Error: "Module not found"**
**Causa:** Módulo no está instalado
**Solución:** El script `run_agripar_seed_simple.sh` lo instala automáticamente

---

## 📚 Recursos Adicionales

- [Documentación Odoo 19](https://www.odoo.com/documentation/19.0/)
- [Odoo Shell Commands](https://www.odoo.com/documentation/19.0/developer/reference/backend/shell.html)
- [Odoo ORM Reference](https://www.odoo.com/documentation/19.0/developer/reference/backend/orm.html)

---

**Última actualización:** 26 de junio, 2026  
**Mantenido por:** Crossnexion EAS  
**Contacto:** +595 972 310933
