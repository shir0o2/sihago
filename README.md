# SiHago - Sistem Keuangan Pribadi

Aplikasi manajemen keuangan pribadi berbasis web dengan fitur **Chat AI** untuk input transaksi menggunakan bahasa natural.

## ✨ Fitur Utama

### 🤖 Chat Transaksi AI
Input transaksi dengan bahasa natural - tidak perlu form manual!
- **Contoh**: "gajian 5 juta" → otomatis tercatat sebagai pemasukan Gaji Rp 5.000.000
- **Contoh**: "beli makan 50rb" → otomatis tercatat sebagai pengeluaran Makanan Rp 50.000
- **Contoh**: "bayar listrik 300ribu" → otomatis tercatat sebagai Tagihan & Utilitas Rp 300.000

Powered by **Google Gemini AI** untuk parsing transaksi secara akurat.

### 📊 Dashboard & Laporan
- Visualisasi arus kas harian
- Breakdown pengeluaran per kategori
- Status anggaran bulanan
- Target tabungan (wishlist)

### 💰 Manajemen Transaksi
- Riwayat transaksi lengkap dengan filter
- Edit dan hapus transaksi (masih via form manual)
- Kategorisasi otomatis oleh AI saat input via chat

### 🎯 Budgeting & Goals
- Set budget per kategori
- Tracking progress tabungan
- Notifikasi saat mendekati limit budget

## 🚀 Quick Start

### Prerequisites
- Node.js 16+
- Akun Supabase (gratis)
- Gemini API Key (gratis)

### Installation

1. **Clone repository**
```bash
git clone <repo-url>
cd sihago
```

2. **Install dependencies**
```bash
npm install
```

3. **Setup environment variables**

Copy `.env.example` ke `.env`:
```bash
cp .env.example .env
```

Edit `.env` dan isi dengan credentials kamu:

```env
# Supabase credentials (dari https://supabase.com/dashboard)
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here

# Gemini API Key (dari https://aistudio.google.com/app/apikey)
VITE_GEMINI_API_KEY=your-gemini-api-key-here
```

4. **Setup database**

Jalankan SQL di Supabase SQL Editor (file: `supabase_schema.sql`):
- Buat tabel `transactions`, `budgets`, `savings_goals`
- Enable Row Level Security (RLS)

5. **Run development server**
```bash
npm run dev
```

Buka browser ke `http://localhost:5173`

## 📁 Struktur Project

```
src/
├── components/
│   ├── ChatInterface.jsx      # ⭐ Chat AI untuk input transaksi
│   ├── TransactionModal.jsx   # Form manual (untuk edit)
│   ├── Layout.jsx
│   └── StatCard.jsx
├── lib/
│   ├── parseTransaction.js    # ⭐ AI parsing dengan Gemini
│   └── supabase.js
├── pages/
│   ├── Dashboard.jsx
│   ├── Transactions.jsx
│   ├── Budget.jsx
│   ├── Wishlist.jsx
│   └── Login.jsx
├── hooks/
│   ├── useTransactions.js
│   ├── useBudgets.js
│   └── useSavingsGoals.js
└── utils/
    └── constants.js
```

## 🎯 Cara Pakai Chat Transaksi

1. Klik tombol **"Chat Transaksi"** di Dashboard atau halaman Transaksi
2. Ketik transaksi dalam bahasa natural, contoh:
   - "gajian 5 juta"
   - "beli kopi 25ribu"
   - "bayar internet 400rb"
   - "dapet bonus 1 juta"
3. AI akan parse dan konfirmasi detail transaksi
4. Klik **"Ya, Simpan"** jika sudah benar
5. Atau klik **"Koreksi"** untuk input ulang

### Format yang Didukung
- Angka: "50rb", "5jt", "1.5juta", "300ribu"
- Jenis: gaji, freelance, beli, bayar, belanja, dll
- Kategori otomatis dipilih AI berdasarkan konteks

## 🔧 Tech Stack

- **Frontend**: React 19 + Vite 8
- **Styling**: Tailwind CSS 4
- **Database**: Supabase (PostgreSQL)
- **Auth**: Supabase Auth
- **AI**: Google Gemini 2.0 Flash
- **Charts**: Recharts
- **Icons**: Lucide React

## 📦 Build & Deploy

### Build untuk production
```bash
npm run build
```

### Deploy ke Vercel
1. Push ke GitHub
2. Import project di [vercel.com](https://vercel.com)
3. Set environment variables di Vercel:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
   - `VITE_GEMINI_API_KEY`
4. Deploy!

`vercel.json` sudah dikonfigurasi untuk SPA routing.

## 🤝 Contributing

Pull requests are welcome! Untuk perubahan besar, buka issue dulu untuk diskusi.

## 📄 License

MIT

---

**SiHago** - Kelola keuangan dengan mudah, cukup chat! 💬💰
