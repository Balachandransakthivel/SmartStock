// SmartStock State & Business Logic Application (India INR Edition)

// --- INITIAL SEED DATA (INDIAN RUPEE & CONTEXT) ---
const INITIAL_CATEGORIES = [
  { id: 'cat-1', name: 'Electronics & Tech', description: 'Gadgets, peripherals, and computer accessories' },
  { id: 'cat-2', name: 'Office Supplies', description: 'Stationery, paper, and desk equipment' },
  { id: 'cat-3', name: 'Furniture & Ergonomics', description: 'Desks, chairs, and workspace setup' },
  { id: 'cat-4', name: 'Networking & Cables', description: 'Routers, switches, and cabling' }
];

const INITIAL_SUPPLIERS = [
  { id: 'sup-1', name: 'Apex Tech Supplies Bengaluru', contact: 'Rajesh Sharma', email: 'sales@apextech.in', phone: '+91 98765 43210', leadTime: 3, rating: 4.9 },
  { id: 'sup-2', name: 'Global Logistics India (Mumbai)', contact: 'Priya Patel', email: 'orders@globallogistics.in', phone: '+91 91234 56789', leadTime: 5, rating: 4.6 },
  { id: 'sup-3', name: 'Prime Office Supplies Delhi', contact: 'Amit Verma', email: 'info@primeoffice.in', phone: '+91 99887 76655', leadTime: 2, rating: 4.8 }
];

const INITIAL_PRODUCTS = [
  {
    id: 'prod-1',
    name: 'Wireless Ergonomic Mouse Pro',
    sku: 'ELEC-WMP-01',
    barcode: '890123456789',
    categoryId: 'cat-1',
    categoryName: 'Electronics & Tech',
    purchasePrice: 1499.00,
    sellingPrice: 2999.00,
    currentStock: 4,
    minimumStock: 10,
    maximumStock: 50,
    supplierId: 'sup-1',
    supplierName: 'Apex Tech Supplies Bengaluru',
    avgDailySales: 3.5,
    leadTimeDays: 3
  },
  {
    id: 'prod-2',
    name: 'Mechanical RGB Keyboard K1',
    sku: 'ELEC-MRK-02',
    barcode: '890123456790',
    categoryId: 'cat-1',
    categoryName: 'Electronics & Tech',
    purchasePrice: 2499.00,
    sellingPrice: 4999.00,
    currentStock: 18,
    minimumStock: 8,
    maximumStock: 40,
    supplierId: 'sup-1',
    supplierName: 'Apex Tech Supplies Bengaluru',
    avgDailySales: 2.1,
    leadTimeDays: 3
  },
  {
    id: 'prod-3',
    name: 'UltraWide 4K Monitor 27"',
    sku: 'ELEC-MON-03',
    barcode: '890123456791',
    categoryId: 'cat-1',
    categoryName: 'Electronics & Tech',
    purchasePrice: 16500.00,
    sellingPrice: 24999.00,
    currentStock: 0,
    minimumStock: 5,
    maximumStock: 25,
    supplierId: 'sup-2',
    supplierName: 'Global Logistics India (Mumbai)',
    avgDailySales: 1.2,
    leadTimeDays: 5
  },
  {
    id: 'prod-4',
    name: 'Ergonomic Mesh Executive Chair',
    sku: 'FURN-CHR-01',
    barcode: '890123456792',
    categoryId: 'cat-3',
    categoryName: 'Furniture & Ergonomics',
    purchasePrice: 6500.00,
    sellingPrice: 12999.00,
    currentStock: 6,
    minimumStock: 8,
    maximumStock: 20,
    supplierId: 'sup-3',
    supplierName: 'Prime Office Supplies Delhi',
    avgDailySales: 0.8,
    leadTimeDays: 2
  },
  {
    id: 'prod-5',
    name: 'USB-C Docking Station 11-in-1',
    sku: 'ELEC-DOCK-05',
    barcode: '890123456793',
    categoryId: 'cat-1',
    categoryName: 'Electronics & Tech',
    purchasePrice: 1800.00,
    sellingPrice: 3499.00,
    currentStock: 25,
    minimumStock: 10,
    maximumStock: 60,
    supplierId: 'sup-1',
    supplierName: 'Apex Tech Supplies Bengaluru',
    avgDailySales: 2.8,
    leadTimeDays: 3
  },
  {
    id: 'prod-6',
    name: 'Recycled Copy Paper A4 (Box of 5)',
    sku: 'OFF-PAP-01',
    barcode: '890123456794',
    categoryId: 'cat-2',
    categoryName: 'Office Supplies',
    purchasePrice: 850.00,
    sellingPrice: 1299.00,
    currentStock: 3,
    minimumStock: 15,
    maximumStock: 100,
    supplierId: 'sup-3',
    supplierName: 'Prime Office Supplies Delhi',
    avgDailySales: 4.5,
    leadTimeDays: 2
  }
];

const INITIAL_PURCHASES = [
  {
    id: 'PO-2026-001',
    supplierId: 'sup-1',
    supplierName: 'Apex Tech Supplies Bengaluru',
    orderDate: '2026-08-25',
    deliveryDate: '2026-08-28',
    status: 'Ordered',
    totalItems: 25,
    totalCost: 47475.00,
    items: [
      { productId: 'prod-1', productName: 'Wireless Ergonomic Mouse Pro', quantity: 15, unitCost: 1499.00 },
      { productId: 'prod-2', productName: 'Mechanical RGB Keyboard K1', quantity: 10, unitCost: 2499.00 }
    ]
  },
  {
    id: 'PO-2026-002',
    supplierId: 'sup-2',
    supplierName: 'Global Logistics India (Mumbai)',
    orderDate: '2026-08-27',
    deliveryDate: '2026-09-01',
    status: 'Pending Approval',
    totalItems: 10,
    totalCost: 165000.00,
    items: [
      { productId: 'prod-3', productName: 'UltraWide 4K Monitor 27"', quantity: 10, unitCost: 16500.00 }
    ]
  }
];

const INITIAL_ACTIVITY_LOGS = [
  { type: 'order', text: 'Issued Purchase Order PO-2026-002 to Global Logistics India (Mumbai)', time: '10 mins ago' },
  { type: 'sale', text: 'Sold 2x Wireless Ergonomic Mouse Pro (₹5,998.00 via UPI)', time: '1 hour ago' },
  { type: 'alert', text: 'Low stock warning: Recycled Copy Paper A4 reached 3 units', time: '3 hours ago' }
];

// Currency Formatter Helper for Indian Rupee (INR)
function formatCurrency(amount) {
  return new Intl.NumberFormat('en-IN', {
    style: 'currency',
    currency: 'INR',
    maximumFractionDigits: 2
  }).format(amount);
}

// --- APP STATE MANAGEMENT ---
let appState = {
  currentUser: null,
  theme: localStorage.getItem('smartstock_theme') || 'light',
  products: JSON.parse(localStorage.getItem('smartstock_products_inr')) || INITIAL_PRODUCTS,
  categories: INITIAL_CATEGORIES,
  suppliers: JSON.parse(localStorage.getItem('smartstock_suppliers_inr')) || INITIAL_SUPPLIERS,
  purchases: JSON.parse(localStorage.getItem('smartstock_purchases_inr')) || INITIAL_PURCHASES,
  activityLogs: INITIAL_ACTIVITY_LOGS,
  posCart: [],
  salesHistory: []
};

// --- DOM READY INITIALIZATION ---
document.addEventListener('DOMContentLoaded', () => {
  applyTheme(appState.theme);
  populateCategorySelects();
  populateSupplierSelects();
});

function saveState() {
  localStorage.setItem('smartstock_products_inr', JSON.stringify(appState.products));
  localStorage.setItem('smartstock_suppliers_inr', JSON.stringify(appState.suppliers));
  localStorage.setItem('smartstock_purchases_inr', JSON.stringify(appState.purchases));
}

// --- AUTHENTICATION & ROLE MANAGEMENT ---
function handleLogin(event) {
  event.preventDefault();
  const email = document.getElementById('login-email').value;
  const role = document.getElementById('login-role').value;

  appState.currentUser = {
    email: email,
    role: role,
    name: role.toUpperCase() + ' User'
  };

  document.getElementById('auth-container').classList.add('hidden');
  document.getElementById('app-container').classList.remove('hidden');

  // Update Sidebar & UI elements
  document.getElementById('user-role-badge').innerText = role.toUpperCase();
  document.getElementById('user-display-name').innerText = appState.currentUser.name;
  document.getElementById('user-display-email').innerText = email;
  document.getElementById('user-avatar-initials').innerText = role.substring(0, 2).toUpperCase();

  showToast(`Welcome back, ${role.toUpperCase()}!`, 'success');
  
  // Render Dashboard
  navigate('dashboard');
  updateAllBadges();
}

function logout() {
  appState.currentUser = null;
  document.getElementById('app-container').classList.add('hidden');
  document.getElementById('auth-container').classList.remove('hidden');
  showToast('Logged out successfully', 'info');
}

// --- THEME TOGGLE ---
function toggleTheme() {
  appState.theme = appState.theme === 'light' ? 'dark' : 'light';
  localStorage.setItem('smartstock_theme', appState.theme);
  applyTheme(appState.theme);
}

function applyTheme(theme) {
  document.documentElement.setAttribute('data-theme', theme);
  const icon = document.getElementById('theme-icon');
  if (icon) {
    icon.className = theme === 'dark' ? 'fa-solid fa-sun' : 'fa-solid fa-moon';
  }
}

// --- NAVIGATION & ROUTING ---
function navigate(viewName, event) {
  if (event) event.preventDefault();

  document.querySelectorAll('.view-section').forEach(sec => sec.classList.remove('active'));
  document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));

  const targetSection = document.getElementById(`view-${viewName}`);
  if (targetSection) targetSection.classList.add('active');

  const activeNav = document.querySelector(`.nav-item[data-view="${viewName}"]`);
  if (activeNav) activeNav.classList.add('active');

  const titles = {
    dashboard: { title: 'Dashboard Overview', sub: 'Real-time inventory metrics & key reorder indicators (INR ₹)' },
    inventory: { title: 'Inventory Management', sub: 'Track product stock, pricing, and category classifications' },
    reorder: { title: 'Smart Reorder System', sub: 'Automated replenishment suggestions based on sales velocity' },
    purchases: { title: 'Purchase Orders', sub: 'Manage supplier orders, pending approvals, and incoming stock' },
    suppliers: { title: 'Suppliers Directory', sub: 'Supplier contacts, lead times, and reliability metrics' },
    sales: { title: 'Sales & POS Terminal', sub: 'Record transactions via UPI/Cash/Card and auto-deduct stock' }
  };

  if (titles[viewName]) {
    document.getElementById('page-title').innerText = titles[viewName].title;
    document.getElementById('page-subtitle').innerText = titles[viewName].sub;
  }

  if (viewName === 'dashboard') renderDashboard();
  if (viewName === 'inventory') renderInventoryTable();
  if (viewName === 'reorder') renderReorderTable();
  if (viewName === 'purchases') renderPurchasesTable();
  if (viewName === 'suppliers') renderSuppliersGrid();
  if (viewName === 'sales') renderPOSCatalog();

  document.getElementById('sidebar').classList.remove('mobile-open');
}

function toggleSidebar() {
  document.getElementById('sidebar').classList.toggle('mobile-open');
}

// --- DASHBOARD & METRICS ---
let salesChartInstance = null;
let categoryChartInstance = null;

function renderDashboard() {
  const products = appState.products;
  const totalProducts = products.length;
  const stockValue = products.reduce((acc, p) => acc + (p.currentStock * p.sellingPrice), 0);
  const lowStock = products.filter(p => p.currentStock > 0 && p.currentStock <= p.minimumStock).length;
  const outOfStock = products.filter(p => p.currentStock <= 0).length;

  document.getElementById('dash-total-products').innerText = totalProducts;
  document.getElementById('dash-stock-value').innerText = formatCurrency(stockValue);
  document.getElementById('dash-low-stock').innerText = lowStock;
  document.getElementById('dash-out-of-stock').innerText = outOfStock;

  // Render Reorder Table in Dashboard
  const reorderBody = document.getElementById('dash-reorder-tbody');
  const needsReorder = products.filter(p => p.currentStock <= p.minimumStock);
  
  reorderBody.innerHTML = needsReorder.length === 0 
    ? `<tr><td colspan="7" class="text-muted text-center">All product stocks are at healthy levels!</td></tr>`
    : needsReorder.map(p => {
        const urgency = p.currentStock <= 0 ? 'Critical' : 'Soon';
        const badgeClass = urgency === 'Critical' ? 'badge-danger' : 'badge-warning';
        const suggested = p.maximumStock - p.currentStock;
        return `
          <tr>
            <td><strong>${p.name}</strong></td>
            <td><code>${p.sku}</code></td>
            <td><strong class="${p.currentStock === 0 ? 'danger-text' : 'warning-text'}">${p.currentStock}</strong></td>
            <td>${p.minimumStock}</td>
            <td>${suggested} units</td>
            <td><span class="badge ${badgeClass}">${urgency}</span></td>
            <td>
              <button class="btn btn-sm btn-primary" onclick="quickCreatePO('${p.id}')">Order Now</button>
            </td>
          </tr>
        `;
      }).join('');

  // Render Recent Activity Feed
  const activityContainer = document.getElementById('dash-activity-feed');
  activityContainer.innerHTML = appState.activityLogs.map(log => `
    <div class="activity-item" style="padding: 10px 0; border-bottom: 1px solid var(--border-color); font-size: 13px;">
      <div style="font-weight: 500;">${log.text}</div>
      <div style="font-size: 11px; color: var(--text-muted);">${log.time}</div>
    </div>
  `).join('');

  initCharts();
}

function initCharts() {
  const ctxSales = document.getElementById('salesChart');
  const ctxCategory = document.getElementById('categoryChart');

  if (salesChartInstance) salesChartInstance.destroy();
  if (categoryChartInstance) categoryChartInstance.destroy();

  // Sales Trend Chart (in INR ₹)
  salesChartInstance = new Chart(ctxSales, {
    type: 'line',
    data: {
      labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      datasets: [{
        label: 'Sales Revenue (₹)',
        data: [42500, 68900, 81000, 54500, 118000, 141000, 98500],
        borderColor: '#2563eb',
        backgroundColor: 'rgba(37, 99, 235, 0.1)',
        fill: true,
        tension: 0.3
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } }
    }
  });

  // Category Breakdown Chart
  const categories = appState.categories.map(c => c.name);
  const categoryCounts = appState.categories.map(c => 
    appState.products.filter(p => p.categoryId === c.id).reduce((sum, p) => sum + p.currentStock, 0)
  );

  categoryChartInstance = new Chart(ctxCategory, {
    type: 'bar',
    data: {
      labels: categories,
      datasets: [{
        label: 'Stock Quantity',
        data: categoryCounts,
        backgroundColor: ['#2563eb', '#059669', '#d97706', '#8b5cf6']
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } }
    }
  });
}

// --- INVENTORY MANAGEMENT ---
function renderInventoryTable() {
  const search = document.getElementById('inv-search-input').value.toLowerCase();
  const categoryFilter = document.getElementById('inv-category-filter').value;
  const statusFilter = document.getElementById('inv-status-filter').value;

  const tbody = document.getElementById('inventory-tbody');

  const filtered = appState.products.filter(p => {
    const matchesSearch = p.name.toLowerCase().includes(search) || p.sku.toLowerCase().includes(search);
    const matchesCategory = !categoryFilter || p.categoryId === categoryFilter;
    
    let status = 'inStock';
    if (p.currentStock <= 0) status = 'outOfStock';
    else if (p.currentStock <= p.minimumStock) status = 'lowStock';
    
    const matchesStatus = !statusFilter || status === statusFilter;

    return matchesSearch && matchesCategory && matchesStatus;
  });

  tbody.innerHTML = filtered.length === 0
    ? `<tr><td colspan="9" class="text-center text-muted">No products found matching filters.</td></tr>`
    : filtered.map(p => {
        let statusBadge = `<span class="badge badge-success">In Stock</span>`;
        if (p.currentStock <= 0) statusBadge = `<span class="badge badge-danger">Out of Stock</span>`;
        else if (p.currentStock <= p.minimumStock) statusBadge = `<span class="badge badge-warning">Low Stock</span>`;

        return `
          <tr>
            <td>
              <div style="font-weight: 600;">${p.name}</div>
            </td>
            <td><code>${p.sku}</code></td>
            <td>${p.categoryName || 'General'}</td>
            <td>${formatCurrency(p.purchasePrice)}</td>
            <td><strong style="color: var(--primary);">${formatCurrency(p.sellingPrice)}</strong></td>
            <td><strong>${p.currentStock}</strong></td>
            <td>${p.minimumStock} / ${p.maximumStock}</td>
            <td>${statusBadge}</td>
            <td>
              <button class="btn btn-sm btn-outline" onclick="editProduct('${p.id}')"><i class="fa-solid fa-pen"></i></button>
              <button class="btn btn-sm btn-outline-danger" onclick="deleteProduct('${p.id}')"><i class="fa-solid fa-trash"></i></button>
            </td>
          </tr>
        `;
      }).join('');
}

function openAddProductModal() {
  document.getElementById('product-modal-title').innerText = 'Add New Product';
  document.getElementById('product-form').reset();
  document.getElementById('pm-id').value = '';
  openModal('product-modal');
}

function editProduct(productId) {
  const p = appState.products.find(x => x.id === productId);
  if (!p) return;

  document.getElementById('product-modal-title').innerText = 'Edit Product';
  document.getElementById('pm-id').value = p.id;
  document.getElementById('pm-name').value = p.name;
  document.getElementById('pm-sku').value = p.sku;
  document.getElementById('pm-category').value = p.categoryId;
  document.getElementById('pm-barcode').value = p.barcode || '';
  document.getElementById('pm-purchase-price').value = p.purchasePrice;
  document.getElementById('pm-selling-price').value = p.sellingPrice;
  document.getElementById('pm-current-stock').value = p.currentStock;
  document.getElementById('pm-min-stock').value = p.minimumStock;
  document.getElementById('pm-max-stock').value = p.maximumStock;
  document.getElementById('pm-supplier').value = p.supplierId || '';

  openModal('product-modal');
}

function saveProduct(event) {
  event.preventDefault();
  const id = document.getElementById('pm-id').value;
  const categoryId = document.getElementById('pm-category').value;
  const categoryObj = appState.categories.find(c => c.id === categoryId);
  const supplierId = document.getElementById('pm-supplier').value;
  const supplierObj = appState.suppliers.find(s => s.id === supplierId);

  const productData = {
    id: id || 'prod-' + Date.now(),
    name: document.getElementById('pm-name').value,
    sku: document.getElementById('pm-sku').value,
    barcode: document.getElementById('pm-barcode').value,
    categoryId: categoryId,
    categoryName: categoryObj ? categoryObj.name : 'General',
    purchasePrice: parseFloat(document.getElementById('pm-purchase-price').value),
    sellingPrice: parseFloat(document.getElementById('pm-selling-price').value),
    currentStock: parseInt(document.getElementById('pm-current-stock').value),
    minimumStock: parseInt(document.getElementById('pm-min-stock').value),
    maximumStock: parseInt(document.getElementById('pm-max-stock').value),
    supplierId: supplierId,
    supplierName: supplierObj ? supplierObj.name : '',
    avgDailySales: 2.0,
    leadTimeDays: supplierObj ? supplierObj.leadTime : 3
  };

  if (id) {
    const index = appState.products.findIndex(x => x.id === id);
    appState.products[index] = productData;
    showToast('Product updated successfully!', 'success');
  } else {
    appState.products.push(productData);
    showToast('Product added successfully!', 'success');
  }

  saveState();
  closeModal('product-modal');
  renderInventoryTable();
  updateAllBadges();
}

function deleteProduct(productId) {
  if (confirm('Are you sure you want to delete this product?')) {
    appState.products = appState.products.filter(p => p.id !== productId);
    saveState();
    renderInventoryTable();
    updateAllBadges();
    showToast('Product deleted.', 'info');
  }
}

// --- SMART REORDER ENGINE ---
function renderReorderTable() {
  const tbody = document.getElementById('reorder-tbody');
  
  let criticalCount = 0;
  let soonCount = 0;
  let normalCount = 0;

  const rows = appState.products.map(p => {
    const safetyStock = Math.ceil(p.minimumStock * 0.5);
    const reorderPoint = Math.ceil((p.avgDailySales * p.leadTimeDays) + safetyStock);
    const suggestedOrder = Math.max(0, p.maximumStock - p.currentStock);
    const estCost = suggestedOrder * p.purchasePrice;
    
    let daysRemaining = Math.floor(p.currentStock / (p.avgDailySales || 1));
    if (p.currentStock <= 0) daysRemaining = 0;

    let urgency = 'Normal';
    let urgencyBadge = `<span class="badge badge-success">Normal</span>`;

    if (p.currentStock <= 0 || p.currentStock <= p.minimumStock) {
      urgency = 'Critical';
      urgencyBadge = `<span class="badge badge-danger"><i class="fa-solid fa-circle-exclamation"></i> Critical</span>`;
      criticalCount++;
    } else if (p.currentStock <= reorderPoint) {
      urgency = 'Soon';
      urgencyBadge = `<span class="badge badge-warning"><i class="fa-solid fa-triangle-exclamation"></i> Soon</span>`;
      soonCount++;
    } else {
      normalCount++;
    }

    return `
      <tr>
        <td>${urgencyBadge}</td>
        <td><strong>${p.name}</strong></td>
        <td><code>${p.sku}</code></td>
        <td><strong class="${p.currentStock <= p.minimumStock ? 'danger-text' : ''}">${p.currentStock}</strong></td>
        <td>${p.minimumStock} / ${p.maximumStock}</td>
        <td>${p.avgDailySales}/day</td>
        <td>${daysRemaining} days</td>
        <td><strong>${suggestedOrder} units</strong></td>
        <td>${formatCurrency(estCost)}</td>
        <td>
          <button class="btn btn-sm btn-primary" onclick="quickCreatePO('${p.id}')">
            <i class="fa-solid fa-cart-plus"></i> Order
          </button>
        </td>
      </tr>
    `;
  }).join('');

  document.getElementById('reorder-critical-count').innerText = criticalCount;
  document.getElementById('reorder-soon-count').innerText = soonCount;
  document.getElementById('reorder-normal-count').innerText = normalCount;

  tbody.innerHTML = rows;
}

// --- PURCHASE ORDERS ---
function renderPurchasesTable() {
  const tbody = document.getElementById('purchases-tbody');
  const search = document.getElementById('po-search').value.toLowerCase();
  const statusFilter = document.getElementById('po-status-filter').value;

  const filtered = appState.purchases.filter(po => {
    const matchesSearch = po.id.toLowerCase().includes(search) || po.supplierName.toLowerCase().includes(search);
    const matchesStatus = !statusFilter || po.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  tbody.innerHTML = filtered.map(po => {
    let badgeClass = 'badge-secondary';
    if (po.status === 'Ordered') badgeClass = 'badge-warning';
    if (po.status === 'Received') badgeClass = 'badge-success';

    return `
      <tr>
        <td><strong>${po.id}</strong></td>
        <td>${po.supplierName}</td>
        <td>${po.orderDate}</td>
        <td>${po.deliveryDate}</td>
        <td>${po.totalItems} items</td>
        <td><strong>${formatCurrency(po.totalCost)}</strong></td>
        <td><span class="badge ${badgeClass}">${po.status}</span></td>
        <td>
          ${po.status !== 'Received' ? `
            <button class="btn btn-sm btn-success" onclick="markPOReceived('${po.id}')" title="Receive Stock">
              <i class="fa-solid fa-boxes-packing"></i> Mark Received
            </button>
          ` : '<span class="text-muted"><i class="fa-solid fa-check"></i> Stock Received</span>'}
        </td>
      </tr>
    `;
  }).join('');
}

function openCreatePOModal() {
  populateSupplierSelects();
  document.getElementById('po-items-list').innerHTML = '';
  addPOItemRow();
  openModal('po-modal');
}

function quickCreatePO(productId) {
  const p = appState.products.find(x => x.id === productId);
  if (!p) return;
  
  openCreatePOModal();
  if (p.supplierId) {
    document.getElementById('po-supplier').value = p.supplierId;
  }
  
  const firstRowProdSelect = document.querySelector('.po-item-prod');
  if (firstRowProdSelect) {
    firstRowProdSelect.value = p.id;
    updatePORowCost(firstRowProdSelect);
  }
}

function addPOItemRow() {
  const container = document.getElementById('po-items-list');
  const rowId = 'po-row-' + Date.now();

  const productOptions = appState.products.map(p => 
    `<option value="${p.id}" data-cost="${p.purchasePrice}">${p.name} (Cost: ${formatCurrency(p.purchasePrice)})</option>`
  ).join('');

  const rowHTML = `
    <div class="form-row align-items-center mb-2" id="${rowId}">
      <div class="form-group flex-1">
        <select class="po-item-prod" onchange="updatePORowCost(this)" required>
          <option value="">-- Select Product --</option>
          ${productOptions}
        </select>
      </div>
      <div class="form-group" style="width: 100px;">
        <input type="number" class="po-item-qty" min="1" value="10" placeholder="Qty" onchange="calculatePOTotal()" required>
      </div>
      <div class="form-group" style="width: 120px;">
        <input type="number" step="0.01" class="po-item-cost" placeholder="Unit Cost" onchange="calculatePOTotal()" required>
      </div>
      <button type="button" class="btn btn-sm btn-outline-danger" onclick="removePORow('${rowId}')">&times;</button>
    </div>
  `;
  container.insertAdjacentHTML('beforeend', rowHTML);
}

function updatePORowCost(selectElem) {
  const selectedOption = selectElem.options[selectElem.selectedIndex];
  const cost = selectedOption.getAttribute('data-cost') || 0;
  const row = selectElem.closest('.form-row');
  row.querySelector('.po-item-cost').value = parseFloat(cost).toFixed(2);
  calculatePOTotal();
}

function removePORow(rowId) {
  const row = document.getElementById(rowId);
  if (row) row.remove();
  calculatePOTotal();
}

function calculatePOTotal() {
  let total = 0;
  document.querySelectorAll('.po-item-prod').forEach(select => {
    const row = select.closest('.form-row');
    const qty = parseInt(row.querySelector('.po-item-qty').value) || 0;
    const cost = parseFloat(row.querySelector('.po-item-cost').value) || 0;
    total += qty * cost;
  });
  document.getElementById('po-calculated-total').innerText = formatCurrency(total);
}

function savePurchaseOrder(event) {
  event.preventDefault();
  const supplierId = document.getElementById('po-supplier').value;
  const supplierObj = appState.suppliers.find(s => s.id === supplierId);
  const deliveryDate = document.getElementById('po-delivery-date').value;

  const items = [];
  let totalItems = 0;
  let totalCost = 0;

  document.querySelectorAll('.po-item-prod').forEach(select => {
    const pId = select.value;
    const pObj = appState.products.find(x => x.id === pId);
    const row = select.closest('.form-row');
    const qty = parseInt(row.querySelector('.po-item-qty').value) || 0;
    const cost = parseFloat(row.querySelector('.po-item-cost').value) || 0;

    if (pObj && qty > 0) {
      items.push({ productId: pId, productName: pObj.name, quantity: qty, unitCost: cost });
      totalItems += qty;
      totalCost += qty * cost;
    }
  });

  if (items.length === 0) {
    showToast('Please add at least one valid item to PO.', 'error');
    return;
  }

  const newPO = {
    id: 'PO-2026-00' + (appState.purchases.length + 1),
    supplierId: supplierId,
    supplierName: supplierObj ? supplierObj.name : 'Supplier',
    orderDate: new Date().toISOString().split('T')[0],
    deliveryDate: deliveryDate,
    status: 'Ordered',
    totalItems: totalItems,
    totalCost: totalCost,
    items: items
  };

  appState.purchases.unshift(newPO);
  appState.activityLogs.unshift({
    type: 'order',
    text: `Issued PO ${newPO.id} to ${newPO.supplierName} (${formatCurrency(totalCost)})`,
    time: 'Just now'
  });

  saveState();
  closeModal('po-modal');
  renderPurchasesTable();
  updateAllBadges();
  showToast(`Purchase Order ${newPO.id} created!`, 'success');
}

function markPOReceived(poId) {
  const po = appState.purchases.find(x => x.id === poId);
  if (!po) return;

  if (confirm(`Mark ${po.id} as Received? This will automatically increase product inventory stocks!`)) {
    po.status = 'Received';
    
    po.items.forEach(item => {
      const prod = appState.products.find(p => p.id === item.productId);
      if (prod) {
        prod.currentStock += item.quantity;
      }
    });

    appState.activityLogs.unshift({
      type: 'stock',
      text: `Received stock from ${po.id} (${po.totalItems} items added to stock)`,
      time: 'Just now'
    });

    saveState();
    renderPurchasesTable();
    updateAllBadges();
    showToast(`Stock from ${po.id} successfully received & added to inventory!`, 'success');
  }
}

// --- SUPPLIERS MANAGEMENT ---
function renderSuppliersGrid() {
  const grid = document.getElementById('suppliers-grid');
  const search = document.getElementById('supplier-search').value.toLowerCase();

  const filtered = appState.suppliers.filter(s => 
    s.name.toLowerCase().includes(search) || s.contact.toLowerCase().includes(search)
  );

  grid.innerHTML = filtered.map(s => `
    <div class="supplier-card">
      <div class="supplier-header">
        <div class="supplier-icon"><i class="fa-solid fa-truck"></i></div>
        <div>
          <h3>${s.name}</h3>
          <span class="badge badge-success"><i class="fa-solid fa-star"></i> ${s.rating} Rating</span>
        </div>
      </div>
      <div class="supplier-details">
        <p><i class="fa-solid fa-user"></i> Contact: ${s.contact}</p>
        <p><i class="fa-solid fa-envelope"></i> ${s.email}</p>
        <p><i class="fa-solid fa-phone"></i> ${s.phone}</p>
        <p><i class="fa-solid fa-clock"></i> Lead Time: <strong>${s.leadTime} Days</strong></p>
      </div>
      <button class="btn btn-outline btn-block" onclick="quickCreatePOWithSupplier('${s.id}')">
        <i class="fa-solid fa-cart-plus"></i> Create Order
      </button>
    </div>
  `).join('');
}

function openAddSupplierModal() {
  document.getElementById('supplier-form').reset();
  openModal('supplier-modal');
}

function saveSupplier(event) {
  event.preventDefault();
  const newSupplier = {
    id: 'sup-' + Date.now(),
    name: document.getElementById('sup-name').value,
    contact: document.getElementById('sup-contact').value,
    email: document.getElementById('sup-email').value,
    phone: document.getElementById('sup-phone').value,
    leadTime: parseInt(document.getElementById('sup-lead-time').value) || 3,
    rating: parseFloat(document.getElementById('sup-rating').value) || 4.5
  };

  appState.suppliers.push(newSupplier);
  saveState();
  populateSupplierSelects();
  closeModal('supplier-modal');
  renderSuppliersGrid();
  showToast('Supplier added successfully!', 'success');
}

// --- SALES & POS (INDIAN GST & UPI INTEGRATION) ---
function renderPOSCatalog() {
  const search = document.getElementById('pos-search').value.toLowerCase();
  const grid = document.getElementById('pos-grid');

  const filtered = appState.products.filter(p => p.name.toLowerCase().includes(search) || p.sku.toLowerCase().includes(search));

  grid.innerHTML = filtered.map(p => `
    <div class="pos-item-card" onclick="addToPOSCart('${p.id}')">
      <div class="pos-item-title">${p.name}</div>
      <div style="font-size: 11px; color: var(--text-muted);">Stock: ${p.currentStock}</div>
      <div class="pos-item-price">${formatCurrency(p.sellingPrice)}</div>
    </div>
  `).join('');
}

function addToPOSCart(productId) {
  const p = appState.products.find(x => x.id === productId);
  if (!p) return;

  if (p.currentStock <= 0) {
    showToast(`Cannot add ${p.name}. Item is out of stock!`, 'error');
    return;
  }

  const existing = appState.posCart.find(item => item.productId === productId);
  if (existing) {
    if (existing.quantity + 1 > p.currentStock) {
      showToast(`Cannot add more. Reached available stock limit (${p.currentStock}).`, 'warning');
      return;
    }
    existing.quantity++;
  } else {
    appState.posCart.push({
      productId: p.id,
      name: p.name,
      price: p.sellingPrice,
      quantity: 1
    });
  }

  renderPOSCart();
}

function renderPOSCart() {
  const container = document.getElementById('pos-cart-items');
  if (appState.posCart.length === 0) {
    container.innerHTML = `
      <div class="empty-state" style="text-align: center; padding: 40px 0; color: var(--text-muted);">
        <i class="fa-solid fa-basket-shopping" style="font-size: 32px; margin-bottom: 8px;"></i>
        <p>Cart is empty. Click items to add.</p>
      </div>
    `;
    updatePOSTotals(0);
    return;
  }

  let subtotal = 0;
  container.innerHTML = appState.posCart.map((item, idx) => {
    const itemTotal = item.price * item.quantity;
    subtotal += itemTotal;
    return `
      <div class="cart-row">
        <div>
          <div style="font-weight: 600;">${item.name}</div>
          <div style="font-size: 12px; color: var(--text-muted);">${formatCurrency(item.price)} x ${item.quantity}</div>
        </div>
        <div style="display: flex; align-items: center; gap: 8px;">
          <strong style="color: var(--primary);">${formatCurrency(itemTotal)}</strong>
          <button class="btn btn-sm btn-outline-danger" onclick="removeFromPOSCart(${idx})">&times;</button>
        </div>
      </div>
    `;
  }).join('');

  updatePOSTotals(subtotal);
}

function removeFromPOSCart(index) {
  appState.posCart.splice(index, 1);
  renderPOSCart();
}

function clearPOSCart() {
  appState.posCart = [];
  renderPOSCart();
}

function updatePOSTotals(subtotal) {
  const gst = subtotal * 0.18; // 18% GST in India
  const total = subtotal + gst;

  document.getElementById('pos-subtotal').innerText = formatCurrency(subtotal);
  document.getElementById('pos-tax').innerText = formatCurrency(gst);
  document.getElementById('pos-total').innerText = formatCurrency(total);
}

function checkoutPOSCart() {
  if (appState.posCart.length === 0) {
    showToast('Cart is empty!', 'warning');
    return;
  }

  // Deduct stocks
  appState.posCart.forEach(cartItem => {
    const prod = appState.products.find(p => p.id === cartItem.productId);
    if (prod) {
      prod.currentStock = Math.max(0, prod.currentStock - cartItem.quantity);
    }
  });

  const totalAmount = document.getElementById('pos-total').innerText;

  appState.activityLogs.unshift({
    type: 'sale',
    text: `Completed POS Sale (${totalAmount} via UPI / Cash)`,
    time: 'Just now'
  });

  appState.posCart = [];
  saveState();
  renderPOSCart();
  renderPOSCatalog();
  updateAllBadges();
  showToast(`Sale recorded successfully! Total Paid: ${totalAmount}`, 'success');
}

// --- HELPERS & POPULATION ---
function populateCategorySelects() {
  const selects = ['pm-category', 'inv-category-filter'];
  const options = appState.categories.map(c => `<option value="${c.id}">${c.name}</option>`).join('');

  selects.forEach(id => {
    const elem = document.getElementById(id);
    if (elem) {
      if (id === 'inv-category-filter') elem.innerHTML = `<option value="">All Categories</option>` + options;
      else elem.innerHTML = options;
    }
  });
}

function populateSupplierSelects() {
  const selects = ['pm-supplier', 'po-supplier'];
  const options = appState.suppliers.map(s => `<option value="${s.id}">${s.name}</option>`).join('');

  selects.forEach(id => {
    const elem = document.getElementById(id);
    if (elem) elem.innerHTML = options;
  });
}

function updateAllBadges() {
  const lowStockCount = appState.products.filter(p => p.currentStock <= p.minimumStock).length;
  document.getElementById('nav-inventory-count').innerText = appState.products.length;
  document.getElementById('nav-reorder-count').innerText = lowStockCount;
  document.getElementById('nav-purchases-count').innerText = appState.purchases.length;
  document.getElementById('notification-counter').innerText = lowStockCount;
}

function toggleNotificationsModal() {
  const container = document.getElementById('notifications-list');
  const lowStockItems = appState.products.filter(p => p.currentStock <= p.minimumStock);

  container.innerHTML = lowStockItems.length === 0
    ? `<p class="text-muted">No urgent stock alerts at this time.</p>`
    : lowStockItems.map(p => `
        <div style="padding: 12px; border-bottom: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center;">
          <div>
            <strong>${p.name}</strong> (${p.sku})<br>
            <span style="font-size: 12px; color: var(--danger);">Current: ${p.currentStock} units | Min Required: ${p.minimumStock}</span>
          </div>
          <button class="btn btn-sm btn-primary" onclick="closeModal('notifications-modal'); quickCreatePO('${p.id}')">Reorder</button>
        </div>
      `).join('');

  openModal('notifications-modal');
}

function openModal(modalId) {
  document.getElementById(modalId).classList.add('active');
}

function closeModal(modalId) {
  document.getElementById(modalId).classList.remove('active');
}

function showToast(message, type = 'info') {
  const container = document.getElementById('toast-container');
  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  toast.innerHTML = `<i class="fa-solid fa-circle-info"></i> ${message}`;

  container.appendChild(toast);
  setTimeout(() => {
    toast.remove();
  }, 3500);
}
