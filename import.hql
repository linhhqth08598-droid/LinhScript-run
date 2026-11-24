// File: test_module_import.hql
// Dung de test co che import & bao mat @ (public / private)

var @TEN_MODULE = "ThuVienPhu_HQL";
var @TY_LE_VAT = 0.1;
var bienBiMat = "KHONG_DUOC_LO";

print("DONG NAY KHONG DUOC IN RA KHI IMPORT!");

func @congHaiSo(x, y) {
    return x + y;
}

func @tinhGiaSauThue(gia) {
    return gia + (gia * @TY_LE_VAT);
}

func hamNoiBo() {
    return "Bi an khi import";
}

class @SanPhamImport {
    var @ten;
    var @gia;
    var giaVon;

    func @init(t, g) {
        this.@ten = t;
        this.@gia = g;
        this.giaVon = g * 0.7;
    }

    func @moTa() {
        return this.@ten + " - Gia: " + this.@gia;
    }

    func layGiaVon() {
        return this.giaVon;
    }

    func @xemLoiNhuan() {
        return this.@gia - this.layGiaVon();
    }
}

class LopNoiBo {
    var @x;
}