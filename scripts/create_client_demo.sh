#!/bin/bash
# Template para crear demo de cliente nuevo
# Uso: ./create_client_demo.sh [nombre_cliente] [industria]

set -e

CLIENT_NAME="${1:-Cliente Demo}"
INDUSTRY="${2:-General}"
DB_NAME="${3:-demo_cliente}"
SCRIPT_NAME="seed_$(echo $CLIENT_NAME | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr -cd '[:alnum:]_')_demo.py"

echo "🎯 Creando script seed para: $CLIENT_NAME"
echo "   Industria: $INDUSTRY"
echo "   Database: $DB_NAME"
echo "   Script: $SCRIPT_NAME"
echo ""

# Crear script Python template
cat > "/opt/odoo/scripts/$SCRIPT_NAME" << PYTHON_EOF
# -*- coding: utf-8 -*-
"""
Seed script para: $CLIENT_NAME
Industria: $INDUSTRY
Fecha: $(date +%Y-%m-%d)
Creado por: Crossnexion EAS
"""
from datetime import datetime

# Modelos de Odoo
partner_model = env['res.partner']
product_model = env['product.product']
lead_model = env['crm.lead']
sale_model = env['sale.order']
employee_model = env['hr.employee']
user_model = env['res.users']
stage_model = env['crm.stage']

print("="*70)
print(f"🚀 Creando datos de demo para: $CLIENT_NAME")
print(f"   Industria: $INDUSTRY")
print("="*70)

# ============================================================
# 1. CREAR EMPLEADOS Y USUARIOS VENDEDORES
# ============================================================
print("\n👥 Creando empleados y usuarios vendedores...")

vendedores_data = [
    {
        'name': 'Vendedor 1',
        'email': 'vendedor1@cliente.com',
        'login': 'vendedor1',
        'password': 'cliente123',
        'phone': '0981 234567',
        'job_title': 'Vendedor Senior',
    },
    {
        'name': 'Vendedor 2',
        'email': 'vendedor2@cliente.com',
        'login': 'vendedor2',
        'password': 'cliente123',
        'phone': '0982 345678',
        'job_title': 'Vendedor',
    },
]

users_created = []
for vendedor_data in vendedores_data:
    # Crear partner
    partner = partner_model.search([('email', '=', vendedor_data['email'])], limit=1)
    if not partner:
        partner = partner_model.create({
            'name': vendedor_data['name'],
            'email': vendedor_data['email'],
            'phone': vendedor_data['phone'],
            'is_company': False,
        })
    
    # Crear empleado
    employee = employee_model.search([('name', '=', vendedor_data['name'])], limit=1)
    if not employee:
        employee = employee_model.create({
            'name': vendedor_data['name'],
            'work_phone': vendedor_data['phone'],
            'work_email': vendedor_data['email'],
        })
        print(f"   ✅ Empleado: {vendedor_data['name']}")
    
    # Crear usuario
    user = user_model.search([('login', '=', vendedor_data['login'])], limit=1)
    if not user:
        user = user_model.create({
            'name': vendedor_data['name'],
            'login': vendedor_data['login'],
            'email': vendedor_data['email'],
            'password': vendedor_data['password'],
            'partner_id': partner.id,
            'employee_ids': [(6, 0, [employee.id])],
        })
        print(f"   ✅ Usuario: {vendedor_data['login']} (password: {vendedor_data['password']})")
        users_created.append(user)
    else:
        print(f"   ℹ️ Usuario ya existe: {vendedor_data['login']}")
        users_created.append(user)

# ============================================================
# 2. CREAR CLIENTE PRINCIPAL
# ============================================================
print("\n🏢 Creando cliente principal...")

cliente_name = "$CLIENT_NAME - Demo"
cliente = partner_model.search([('name', '=', cliente_name)], limit=1)
if not cliente:
    cliente = partner_model.create({
        'name': cliente_name,
        'vat': '80000000-0',  # RUC (editar según corresponda)
        'email': 'info@cliente.com',
        'phone': '021 123456',
        'street': 'Av. Principal 1234',
        'city': 'Asunción',
        'country_id': env.ref('base.py').id,  # Paraguay
        'is_company': True,
    })
    print(f"   ✅ Cliente creado: {cliente.name}")
else:
    print(f"   ℹ️ Cliente ya existe: {cliente.name}")

# ============================================================
# 3. CREAR PRODUCTOS CARACTERÍSTICOS
# ============================================================
print("\n📦 Creando productos...")

# Obtener categoría por defecto
default_categ = env.ref('product.product_category_all', raise_if_not_found=False)
if not default_categ:
    default_categ = partner_model.env['product.category'].search([], limit=1)

productos_data = [
    {
        'name': 'Producto Principal 1',
        'type': 'product',
        'list_price': 1000000,
        'standard_price': 600000,
        'categ_id': default_categ.id if default_categ else False,
        'description_sale': 'Producto característico de $INDUSTRY',
    },
    {
        'name': 'Producto Principal 2',
        'type': 'product',
        'list_price': 2500000,
        'standard_price': 1500000,
        'categ_id': default_categ.id if default_categ else False,
        'description_sale': 'Producto premium',
    },
    {
        'name': 'Servicio Profesional',
        'type': 'service',
        'list_price': 500000,
        'standard_price': 200000,
        'categ_id': default_categ.id if default_categ else False,
        'description_sale': 'Servicio de consultoría/profesional',
    },
]

products_created = []
for prod_data in productos_data:
    product = product_model.search([('name', '=', prod_data['name'])], limit=1)
    if not product:
        product = product_model.create(prod_data)
        print(f"   ✅ Producto: {product.name} - ₲ {product.list_price:,.0f}")
        products_created.append(product)
    else:
        print(f"   ℹ️ Producto ya existe: {product.name}")
        products_created.append(product)

# ============================================================
# 4. CREAR OPORTUNIDADES CRM
# ============================================================
print("\n💼 Creando oportunidades CRM...")

# Obtener etapa del CRM
prop_stage = stage_model.search([('name', '=', 'Proposition')], limit=1)
if not prop_stage:
    prop_stage = stage_model.search([], limit=1)

oportunidades_data = [
    {
        'name': f'Oportunidad Demo - Venta de Productos',
        'revenue': 5000000.0,
        'probability': 60.0,
        'vendedor_idx': 0,
    },
    {
        'name': f'Oportunidad Demo - Servicio Profesional',
        'revenue': 2000000.0,
        'probability': 50.0,
        'vendedor_idx': 1,
    },
]

for opp_data in oportunidades_data:
    vendedor = users_created[opp_data['vendedor_idx']] if opp_data['vendedor_idx'] < len(users_created) else False
    opp_name = f"{opp_data['name']} - {cliente.name}"
    
    opp = lead_model.search([('name', '=', opp_name)], limit=1)
    if not opp:
        opp = lead_model.create({
            'name': opp_name,
            'partner_id': cliente.id,
            'expected_revenue': opp_data['revenue'],
            'stage_id': prop_stage.id,
            'type': 'opportunity',
            'probability': opp_data['probability'],
            'user_id': vendedor.id if vendedor else False,
        })
        vendedor_name = vendedor.name if vendedor else "Sin asignar"
        print(f"   ✅ Oportunidad: {opp.name}")
        print(f"      Vendedor: {vendedor_name}")
        print(f"      Revenue: ₲ {opp.expected_revenue:,.0f}")
        print(f"      Probabilidad: {opp.probability}%")
    else:
        print(f"   ℹ️ Oportunidad ya existe: {opp.name}")

# ============================================================
# 5. CREAR PEDIDO DE VENTA
# ============================================================
print("\n Creando pedido de venta...")

if products_created and users_created:
    sale = sale_model.search([('partner_id', '=', cliente.id)], limit=1)
    if not sale:
        sale = sale_model.create({
            'partner_id': cliente.id,
            'user_id': users_created[0].id,
            'order_line': [(0, 0, {
                'product_id': products_created[0].id,
                'product_uom_qty': 5,
                'product_uom': products_created[0].uom_id.id,
            })],
        })
        sale.action_confirm()
        print(f"   ✅ Pedido de venta creado: {sale.name}")
        print(f"      Total: ₲ {sale.amount_total:,.0f}")
        print(f"      Estado: {sale.state}")
    else:
        print(f"   ℹ️ Pedido ya existe: {sale.name}")

# ============================================================
# RESUMEN FINAL
# ============================================================
env.cr.commit()

print("\n" + "="*70)
print(" RESUMEN DE LA DEMO")
print("="*70)

print("\n👥 USUARIOS CREADOS:")
for u in users_created:
    print(f"   • {u.name} ({u.login})")
    print(f"     Email: {u.email}")
    print(f"     Password: cliente123")

print("\n CLIENTE:")
print(f"   • {cliente.name}")
print(f"     RUC: {cliente.vat}")
print(f"     Email: {cliente.email}")

print("\n📦 PRODUCTOS:")
for p in products_created:
    print(f"   • {p.name} - ₲ {p.list_price:,.0f}")

print("\n OPORTUNIDADES CRM:")
opps = lead_model.search([('partner_id', '=', cliente.id), ('type', '=', 'opportunity')], limit=10)
for opp in opps:
    vendedor_name = opp.user_id.name if opp.user_id else "Sin asignar"
    print(f"   • {opp.name}")
    print(f"     Vendedor: {vendedor_name}")
    print(f"     Revenue: ₲ {opp.expected_revenue:,.0f}")

print("\n📦 DOCUMENTOS COMERCIALES:")
sales = sale_model.search([('partner_id', '=', cliente.id)], limit=5)
for so in sales:
    print(f"   • {so.name} - Estado: {so.state}")
    print(f"     Total: ₲ {so.amount_total:,.0f}")

print("\n🎯 ACCESO AL SISTEMA:")
print("   URL: http://localhost:8084")
print("   Admin: admin / admin")
print("   Vendedores: vendedor1 / vendedor2 (password: cliente123)")

print("\n" + "="*70)
print(f"🎉 ¡Datos de demo para $CLIENT_NAME creados exitosamente!")
print("="*70)
PYTHON_EOF

echo "✅ Script creado: /opt/odoo/scripts/$SCRIPT_NAME"
echo ""
echo "📝 Para ejecutar el script:"
echo "   cd /opt/odoo/scripts"
echo "   docker exec -i odoo_web_8084 odoo shell -d $DB_NAME < $SCRIPT_NAME"
echo ""
echo "📌 Próximos pasos:"
echo "   1. Editar el script con datos reales del cliente"
echo "   2. Asegurar que la DB esté inicializada"
echo "   3. Ejecutar el script"
echo "   4. Verificar datos creados en el navegador"
