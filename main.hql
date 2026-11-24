// =========================================================
//   LINHSCRIPT (HQL) - FULL TEST SUITE (28 THU VIEN + IMPORT)
//   Chuan theo Interpreter.java & Lexer.java
// =========================================================

use hql.io;
use hql.math;
use hql.net;
use hql.sys;
use hql.util;
use hql.ui;
use hql.crypto;
use hql.database;
use hql.time;
use hql.regex;
use hql.game;
use hql.pc;
use hql.logging;
use hql.image;
use hql.chart;
use hql.config;
use hql.csv;
use hql.xml;
use hql.binary;
use hql.color;
use hql.socket;
use hql.schedule;
use hql.env;
use hql.export;
use hql.web;
use hql.mail;
use hql.mang;
use hql.app;

import "import.hql";

var passCount = 0;
var failCount = 0;
var failList = [];

func pass(name) {
    passCount = passCount + 1;
    print("[PASS] " + name);
}

func fail(name, err) {
    failCount = failCount + 1;
    failList.push(name + " -> " + err);
    print("[FAIL] " + name + " | Loi: " + err);
}

func @testFunc() { return "Func OK"; }
func @nhanDoi(x) { return x * 2; }
func @locChan(x) { return x % 2 == 0; }
func @tinhTong(acc, curr) { return acc + curr; }

var taskDem = 0;
func taskHello() { taskDem = taskDem + 1; }
func taskJobA() { var x = 1 + 1; }
func taskJobB() { var y = 2 + 2; }
func webPingRoute() { printWeb("WEB_ROUTE_OK"); }

class DongVat {
    var @ten;
    var biMat;
    func @init(t) {
        this.@ten = t;
        this.biMat = "secret";
    }
    func @keu() { return this.@ten + " keu"; }
    func hamRieng() { return this.biMat; }
    func @docBiMat() { return this.hamRieng(); }
}

class Cho extends DongVat {
    func @init(t) {
        this.@ten = t;
        this.biMat = "dog_secret";
    }
    func @sua() { return this.@ten + " sua gau gau"; }
}

print("=========================================================");
print(">>> BAT DAU TEST FULL CU PHAP, IMPORT & 28 THU VIEN <<<");
print("=========================================================");

// ---------------------------------------------------------
// [0A] TEST IMPORT & GOI BIEN / FUNC / CLASS PUBLIC (@)
// ---------------------------------------------------------
print("\n--- [0A] IMPORT MODULE & @ PUBLIC/PRIVATE ---");
try {
    print("Bien @ public: TEN_MODULE=" + @TEN_MODULE + ", TY_LE_VAT=" + @TY_LE_VAT);
    print("Func @ public: @congHaiSo(15, 25)=" + @congHaiSo(15, 25) + ", @tinhGiaSauThue(1000)=" + @tinhGiaSauThue(1000));

    var sp = new @SanPhamImport("Laptop Legion", 2000);
    print("Class @ public: " + sp.@moTa() + " | Loi nhuan=" + sp.@xemLoiNhuan());

    // Kiem tra chan thanh phan khong co @ tu file import
    var chanHamNoiBo = false;
    try { hamNoiBo(); } catch (e1) { chanHamNoiBo = true; }

    var chanLopNoiBo = false;
    try { var xLop = new LopNoiBo(); } catch (e2) { chanLopNoiBo = true; }

    var chanPrivateMethod = false;
    try { sp.layGiaVon(); } catch (e3) { chanPrivateMethod = true; }

    print("Bao mat import: chanHamNoiBo=" + chanHamNoiBo + ", chanLopNoiBo=" + chanLopNoiBo + ", chanPrivateMethod=" + chanPrivateMethod);
    pass("IMPORT MODULE (@ public/private)");
} catch (e) {
    fail("IMPORT MODULE (@ public/private)", e);
}

// ---------------------------------------------------------
// [0B] CORE: TOAN TU, DIEU KHIEN, MAP, TEXT BLOCK, OOP, STRING, LIST
// ---------------------------------------------------------
print("\n--- [0B] CORE, MAP, OOP, STRING, LIST ---");
try {
    var a = 2;
    var b = 1;
    a += 5;
    a -= 1;
    a *= 2;
    a /= 2;
    var powVal = 2 ^ 3;
    var checkNot = not false;
    var checkLogic = !false && (a > b || false);
    var ternary = (a > b) ? "LonHon" : "NhoHon";
    print("Toan tu: a=" + a + ", 2^3=" + powVal + ", ternary=" + ternary + ", logic=" + checkLogic + "/" + checkNot);

    // Test rieng ++ o cuoi khoi (tranh bug gop dong trong splitCommands)
    var incTest = 5;
    try {
        incTest++
    } catch (eInc) {
        print("Luu y ++: " + eInc);
    }
    print("incTest sau ++: " + incTest);

    var tb = """
        Dong 1
        Dong 2
    """;
    print("TextBlock len=" + len(tb));

    // Re nhanh & Switch
    var kqIf = "";
    if (a < 0) { kqIf = "am"; }
    else if (a > 0) { kqIf = "duong"; }
    else { kqIf = "khong"; }

    var kqSw = "";
    switch (2) {
        case 1: kqSw = "mot"; break;
        case 2: kqSw = "hai"; break;
        default: kqSw = "khac";
    }
    print("if/switch: " + kqIf + " / " + kqSw);
    // Vong lap + break/continue
    var sumFor = 0;
    for i in 1 .. 10 {
        if (i == 3) { continue; }
        if (i == 6) { break; }
        sumFor += i;
    }
    var w = 0;
    while (w < 3) { w = w + 1; }
    print("Loops: sumFor=" + sumFor + ", while=" + w);

    // Built-in core
    print("call=" + call("@testFunc") + ", type=" + type(a) + ", str=" + str(123) + ", num=" + num("45.5") + ", bool=" + bool(1));

    // Map literal
    var sv = { "ten": "Linh", tuoi: 17, "diem": [9, 10], "dc": { "tinh": "Ha Noi" } };
    sv.tuoi += 1;
    sv["lop"] = "SD2002";
    var mapKeys = [];
    for k in sv { mapKeys.push(k); }
    print("Map: ten=" + sv.ten + ", tuoi=" + sv["tuoi"] + ", tinh=" + sv.dc.tinh + ", keys=" + mapKeys);

    // OOP + @ public/private
    var dog = new Cho("Muc");
    print("OOP: " + dog.@keu() + " | " + dog.@sua() + " | " + dog.@docBiMat());
    var blockedPrivate = false;
    try { dog.hamRieng(); } catch (ePriv) { blockedPrivate = true; }
    print("OOP Private check: " + blockedPrivate);

    // List methods
    var lst = [10, 20, 30];
    lst.push(40);
    lst.add(50);
    var popped = lst.pop();
    lst.set(0, 99);
    lst.insert(1, 15);
    var removed = lst.removeAt(1);
    var idx20 = lst.indexOf(20);
    print("List: size=" + size(lst) + ", len=" + len(lst) + ", pop=" + popped + ", rm=" + removed + ", idx20=" + idx20 + ", join=" + lst.join("-"));
    lst.clear();

    var arr = [1, 2, 3, 4, 5];
    print("map=" + arr.map("@nhanDoi") + ", filter=" + arr.filter("@locChan") + ", reduce=" + arr.reduce("@tinhTong", 0));

    // String methods
    var s = "  Linh Script  ";
    print("String: trim='" + s.trim() + "', strip='" + s.strip() + "', lstrip='" + s.lstrip() + "', rstrip='" + s.rstrip() + "'");
    print("String2: sub=" + s.trim().substring(0, 4) + ", low=" + s.trim().toLowerCase() + ", up=" + s.trim().toUpperCase());
    print("String3: idx=" + s.indexOf("S") + ", lastIdx=" + s.lastIndexOf("i") + ", starts=" + s.startsWith(" ") + ", ends=" + s.endsWith(" "));
    print("String4: rep=" + s.trim().replace("Script", "HQL") + ", ins=" + "Linh".insert(4, "HQL") + ", rmAt=" + "HQL".removeAt(0));
    print("String5: split=" + "a,b,c".split(",") + ", contains=" + "LinhScript".contains("Script") + ", containsRegex=" + "abc123".containsRegex("[0-9]+") + ", matches=" + "abc123".matches("[a-z]+[0-9]+"));

    // Try-Catch-Finally
    var finOk = false;
    try { throw "Loi gia lap"; } catch (eTry) { print("Catch OK: " + eTry); } finally { finOk = true; }
    print("Finally OK: " + finOk);

    pass("CORE + MAP + OOP + STRING + LIST");
} catch (e) {
    fail("CORE + MAP + OOP + STRING + LIST", e);
}

// ---------------------------------------------------------
// [1] HQL.IO
// ---------------------------------------------------------
print("\n--- [1] HQL.IO ---");
try {
    create("io_test_dir/sub.txt");
    write("io_test.txt", "HQL\n", false);
    write("io_test.txt", "Line2", true);
    var r1 = read("io_test.txt");
    writeA("io_test.txt", ["Add1", "Add2"], false);
    var r2 = readA("io_test.txt");
    print("read/readA: " + r1.replace("\n", " ") + " | " + r2);
    print("meta: exists=" + exists("io_test.txt") + ", size=" + fileSize("io_test.txt") + ", name=" + getName("io_test.txt") + ", ext=" + extension("io_test.txt") + ", isDir=" + isDir("io_test_dir") + ", mod=" + lastModified("io_test.txt"));
    print("sysDirs: home=" + homeDir() + ", work=" + workingDir() + ", freeGB=" + round(freeSpace()) + ", totalGB=" + round(totalSpace()));
    copy("io_test.txt", "io_copy.txt");
    move("io_copy.txt", "io_moved.txt");
    print("list count=" + len(list(".")) + ", listFull count=" + len(listFull(".")) + ", find txt=" + len(find("*.txt", ".")));
    zip("io_test_dir", "io_test_dir.zip");
    unzip("io_test_dir.zip", "io_unzip_dir");
    delete("io_moved.txt");
    delete("io_test.txt");
    delete("io_test_dir.zip");
    delete("io_test_dir");
    delete("io_unzip_dir");
    pass("hql.io");
} catch (e) {
    fail("hql.io", e);
}

// ---------------------------------------------------------
// [2] HQL.MATH
// ---------------------------------------------------------
print("\n--- [2] HQL.MATH ---");
try {
    print("basic: sqrt=" + sqrt(16) + ", cbrt=" + cbrt(64) + ", pow=" + pow(2, 3) + ", abs=" + abs(-5) + ", hypot=" + hypot(3, 4) + ", isqrt=" + isqrt(27) + ", exp=" + round(exp(1)));
    print("round: round=" + round(4.5) + ", ceil=" + ceil(4.1) + ", floor=" + floor(4.9) + ", trunc=" + trunc(-4.99));
    print("trig: sin=" + sin(0) + ", cos=" + cos(0) + ", tan=" + tan(0) + ", rad=" + toRadians(180) + ", deg=" + degrees(PI));
    print("log/comb: log=" + log(E) + ", log10=" + log10(100) + ", log2=" + log2(16) + ", fact=" + factorial(5) + ", gcd=" + gcd(12, 8) + ", lcm=" + lcm(4, 6) + ", comb=" + comb(5, 2) + ", perm=" + perm(5, 2));
    print("util: max=" + max(1, 2) + ", min=" + min(1, 2) + ", clamp=" + clamp(20, 0, 10) + ", random=" + random(1, 10) + ", fsum=" + fsum([0.1, 0.2]) + ", isclose=" + isclose(0.3, 0.3));
    print("constants: PI=" + PI + ", E=" + E + ", KM_TO_MILE=" + KM_TO_MILE + ", INCH_TO_CM=" + INCH_TO_CM);
    print("units: list=" + len(listUnits()) + ", km->m=" + unitConvert(5, "km", "m") + ", C->F=" + celsiusToFahrenheit(30) + ", F->C=" + fahrenheitToCelsius(86) + ", cmp=" + unitCompare(1, "km", 1000, "m"));
    print("stats: mean=" + mean([2, 4, 6]) + ", median=" + median([2, 4, 6]) + ", var=" + variance([2, 4, 6]) + ", std=" + stddev([2, 4, 6]) + ", corr=" + correlation([1, 2, 3], [2, 4, 6]) + ", reg=" + linearRegression([1, 2, 3], [2, 4, 6]));
    print("matrix: mul=" + matrixMultiply([[1, 2]], [[2], [1]]) + ", T=" + matrixTranspose([[1, 2]]) + ", det=" + matrixDeterminant([[1, 2], [3, 4]]) + ", inv=" + matrixInverse([[1, 0], [0, 2]]));
    pass("hql.math");
} catch (e) {
    fail("hql.math", e);
}

// ---------------------------------------------------------
// [3] HQL.NET
// ---------------------------------------------------------
print("\n--- [3] HQL.NET ---");
try {
    setTimeout(5000);
    addHeader("User-Agent", "LinhScript-Test");
    setCookie("Session=Test123");
    print("net info: online=" + isOnline() + ", IP=" + getIP() + ", Host=" + getHost() + ", ping=" + ping("127.0.0.1") + ", port80=" + checkPort("127.0.0.1", 80));
    if (isOnline()) {
        var body = httpGet("http://example.com");
        print("httpGet: status=" + getStatusCode() + ", type=" + getContentType() + ", len=" + len(body) + ", hdr=" + getResponseHeader("Content-Type"));
        httpPost("http://example.com", "test=1");
        print("httpPost status=" + getStatusCode());
        var dlOk = download("http://example.com", "test_dl.html");
        print("download=" + dlOk);
        delete("test_dl.html");
    } else {
        print("Bo qua httpGet/download vi may dang offline.");
    }
    ignoreSSL();
    pass("hql.net");
} catch (e) {
    fail("hql.net", e);
}

// ---------------------------------------------------------
// [4] HQL.SYS
// ---------------------------------------------------------
print("\n--- [4] HQL.SYS ---");
try {
    print("OS: " + osName() + " (" + osArch() + ") | User=" + userName() + " | Uptime=" + uptime() + "m");
    print("CPU: " + cpuModel() + " | " + cpuCores() + "C/" + cpuThreads() + "T | " + cpuSpeed() + "GHz | " + cpuVendor());
    print("GPU: " + gpuModel() + " | VRAM=" + gpuMemory() + " | Driver=" + gpuDriver() + " | Res=" + resolution());
    print("RAM: total=" + round(totalRam()) + "GB, free=" + round(freeRam()) + "GB, used=" + round(usedRam()) + "GB, speed=" + ramSpeed());
    print("HW: machine=" + machineModel() + " | MB=" + mainboard() + " | BIOS=" + biosVersion() + " | SN=" + serialNumber());
    print("Disk: " + diskName() + " | status=" + diskStatus() + " | temp=" + diskTemp() + " | wear=" + diskWear());
    print("env(PATH) len=" + len(env("PATH")) + " | execRead=" + execRead("cmd /c echo HQL_SYS_OK"));
    gc();
    pass("hql.sys");
} catch (e) {
    fail("hql.sys", e);
}

// ---------------------------------------------------------
// [5] HQL.UTIL
// ---------------------------------------------------------
print("\n--- [5] HQL.UTIL ---");
try {
    print("arr: sort=" + sort(["c", "a", "b"]) + ", rev=" + reverse([1, 2, 3]) + ", shuf=" + shuffle([1, 2, 3]) + ", uniq=" + unique([1, 1, 2, 2, 3]) + ", cnt=" + count([1, 1, 2], 1));
    print("hash: md5=" + md5("HQL") + ", sha256=" + sha256("HQL"));
    var b64 = base64Encode("LinhScript");
    print("b64: enc=" + b64 + ", dec=" + base64Decode(b64) + ", uuid=" + uuid());
    print("json: toJson=" + toJson([1, 2, 3]) + ", fromJson=" + fromJson("[1, 2, 3]") + ", esc=" + jsonEscape("Hi \"HQL\"\nNext"));
    print("range=" + range(0, 10, 2));
    sleep(50);
    pass("hql.util");
} catch (e) {
    fail("hql.util", e);
}

// ---------------------------------------------------------
// [6] HQL.UI
// ---------------------------------------------------------
print("\n--- [6] HQL.UI ---");
try {
    window("HQL UI Test", 400, 300);
    setLayout("flow");
    var lblId = label("lbl1", "Xin chao HQL");
    var btnId = button("btn1", "Bam thu", "@testFunc");
    var txtId = textField("txt1");
    var taId = textArea("ta1");
    var chkId = checkbox("chk1", "Dong y");
    var rbId = radioButton("rb1", "grp1", "Chon A");
    var cbId = comboBox("cb1", ["A", "B", "C"]);
    var tblId = table("tbl1", ["ID", "Ten"], [["1", "An"], ["2", "Binh"]]);
    var pbId = progressBar("pb1", 75);
    setStyle(btnId, "color", "#ffffff");
    setStyle(btnId, "bg", "#2563eb");
    setStyle(lblId, "font_weight", "bold");
    setStyle(txtId, "text", "HelloUI");
    onHover(btnId, "@testFunc");
    onKeyPress(txtId, "@testFunc");
    print("UI getText: txt=" + getText(txtId) + ", chk=" + getText(chkId) + ", cb=" + getText(cbId));
    show();
    sleep(100);
    hide();
    close();
    pass("hql.ui");
} catch (e) {
    fail("hql.ui", e);
}

// ---------------------------------------------------------
// [7] HQL.CRYPTO
// ---------------------------------------------------------
print("\n--- [7] HQL.CRYPTO ---");
try {
    var enc = encrypt("Bi mat HQL", "MatKhauBiMat");
    var dec = decrypt(enc, "MatKhauBiMat");
    var keys = generateKeys();
    var sig = sign("HopDongHQL", keys[1]);
    var ver = verify("HopDongHQL", sig, keys[0]);
    var randHex = secureRandom(16);
    var hashPw = pbkdf2("MatKhau123", "MuoiTest");
    print("AES=" + dec + " | RSA verify=" + ver + " | rand=" + randHex + " | pbkdf2 len=" + len(hashPw));
    pass("hql.crypto");
} catch (e) {
    fail("hql.crypto", e);
}

// ---------------------------------------------------------
// [8] HQL.DATABASE (SQL Server qua .henv)
// ---------------------------------------------------------
print("\n--- [8] HQL.DATABASE ---");
try {
    dbPoolSize(5, 1);
    var dbOk = connectEnv();
    if (dbOk) {
        print("DB stats: " + dbPoolStats() + " | isOpen=" + isOpen());
        execute("IF OBJECT_ID('hql_test_tbl', 'U') IS NOT NULL DROP TABLE hql_test_tbl");
        execute("CREATE TABLE hql_test_tbl (id INT IDENTITY(1,1) PRIMARY KEY, ten NVARCHAR(100), diem FLOAT)");
        executeSafe("INSERT INTO hql_test_tbl(ten, diem) VALUES (?, ?)", ["An", 8.5]);
        print("identity=" + identity());
        executeBatch("INSERT INTO hql_test_tbl(ten, diem) VALUES (?, ?)", [["Binh", 9.0], ["Chi", 7.5]]);
        print("query rows=" + len(query("SELECT * FROM hql_test_tbl")));
        print("querySafe=" + querySafe("SELECT * FROM hql_test_tbl WHERE ten=?", ["An"]));
        print("fetchOne=" + fetchOne("SELECT * FROM hql_test_tbl WHERE ten=?", ["Binh"]));
        print("queryValue count=" + queryValue("SELECT COUNT(*) FROM hql_test_tbl"));
        beginTransaction();
        execute("UPDATE hql_test_tbl SET diem = 10 WHERE ten = 'An'");
        rollback();
        beginTransaction();
        execute("UPDATE hql_test_tbl SET diem = 9.5 WHERE ten = 'An'");
        commit();
        print("tables count=" + len(tables()) + " | cols=" + columns("hql_test_tbl"));
        exportCSV("SELECT * FROM hql_test_tbl", "test_db_out.csv");
        execute("DROP TABLE hql_test_tbl");
        closeDB();
        delete("test_db_out.csv");
        pass("hql.database");
    } else {
        print("[SKIP] hql.database: " + dbError());
    }
} catch (e) {
    fail("hql.database", e);
}

// ---------------------------------------------------------
// [8B] HQL.DATABASE - NOSQL (MongoDB qua db.henv: nosql.url + nosql.name)
// ---------------------------------------------------------
print("\n--- [8B] HQL.NOSQL (MongoDB) ---");
try {
    if (nosqlConnectEnv()) {
        var nsId = nosqlInsert("hql_test_col", { "ten": "An", "diem": 8.5, "tags": ["a", "b"], "dc": { "tp": "HN" } });
        nosqlInsertMany("hql_test_col", [ { "ten": "Binh", "diem": 9 }, { "ten": "Chi", "diem": 7.5 } ]);
        print("count=" + nosqlCount("hql_test_col") + " | findOne=" + nosqlFindOne("hql_test_col", { "_id": nsId }).ten);
        print("find>8 rows=" + len(nosqlFind("hql_test_col", { "diem": { "$gt": 8 } }, { "sort": { "diem": -1 }, "limit": 5 })));
        print("update=" + nosqlUpdate("hql_test_col", { "ten": "An" }, { "$inc": { "diem": 1 } }) + " | doc=" + nosqlDoc("{ten: ?}", ["Linh"]));
        print("collections=" + nosqlCollections() + " | ping=" + nosqlPing());
        print("delete=" + nosqlDeleteMany("hql_test_col", {}));
        nosqlDrop("hql_test_col");
        nosqlClose();
        pass("hql.database (NoSQL)");
    } else {
        print("[SKIP] hql.database NoSQL: " + nosqlError());
    }
} catch (e) {
    fail("hql.database (NoSQL)", e);
}

// ---------------------------------------------------------
// [9] HQL.TIME
// ---------------------------------------------------------
print("\n--- [9] HQL.TIME ---");
try {
    var tNow = now();
    var tDay = today();
    print("now=" + tNow + " | today=" + tDay + " | time=" + currentTime());
    print("format=" + format(tNow, "dd/MM/yyyy HH:mm:ss") + " | parse=" + parse("2026-11-23", "yyyy-MM-dd"));
    print("add: +10m=" + addMinutes(tNow, 10) + " | +1d=" + addDays(tDay, 1) + " | +1M=" + addMonths(tDay, 1) + " | +1Y=" + addYears(tDay, 1));
    print("calc: between=" + daysBetween("2026-01-01", "2026-12-31") + " | Y/M/D/W=" + getYear(tDay) + "/" + getMonth(tDay) + "/" + getDay(tDay) + "/" + getWeekday(tDay));
    print("check: age=" + age("2009-05-20") + " | weekend=" + isWeekend(tDay) + " | past=" + isPast("2020-01-01") + " | countdown=" + countdown(tNow));
    pass("hql.time");
} catch (e) {
    fail("hql.time", e);
}

// ---------------------------------------------------------
// [10] HQL.REGEX
// ---------------------------------------------------------
print("\n--- [10] HQL.REGEX ---");
try {
    var pat = compile("[0-9]+");
    print("matches=" + matches("A1", "^[A-Z][0-9]$") + " | contains=" + containsRegex("A1", pat) + " | find=" + findRegex("A12B", pat));
    print("findAll=" + findAll("a1b22c333", pat) + " | rep=" + replaceRegex("a1b2", pat, "X") + " | repFirst=" + replaceFirst("a1b2", pat, "X"));
    print("split=" + splitRegex("A  B   C", "\\s+") + " | group=" + group("SP-042", "SP-([0-9]+)", 1) + " | groups=" + groups("A1", "([A-Z])([0-9])") + " | quote=" + quote("a.b"));
    pass("hql.regex");
} catch (e) {
    fail("hql.regex", e);
}

// ---------------------------------------------------------
// [11] HQL.CHART
// ---------------------------------------------------------
print("\n--- [11] HQL.CHART ---");
try {
    var c1 = drawBarChart([10, 25, 15], ["A", "B", "C"], "Bar Test");
    var c2 = drawLineChart([5, 15, 10], ["T1", "T2", "T3"], "Line Test");
    var c3 = drawPieChart([30, 70], ["X", "Y"], "Pie Test");
    var c4 = drawScatterChart([1, 2, 3], [2, 5, 4], "Scatter Test");
    var c5 = drawHistogram([1, 2, 2, 3, 4, 4, 4, 5], 5, "Hist Test");
    setChartSize(c1, 400, 300);
    setChartColor(c1, "#7C3AED");
    print("chartTitle=" + chartTitle(c1) + " | IDs=" + c1 + "," + c2 + "," + c3 + "," + c4 + "," + c5);
    saveChart(c1, "test_sample.png");
    pass("hql.chart");
} catch (e) {
    fail("hql.chart", e);
}

// ---------------------------------------------------------
// [12] HQL.IMAGE
// ---------------------------------------------------------
print("\n--- [12] HQL.IMAGE ---");
try {
    var imgId = loadImage("test_sample.png");
    print("loadImage=" + imgId + " | size=" + imageWidth(imgId) + "x" + imageHeight(imgId));
    resizeImage(imgId, 120, 120);
    cropImage(imgId, 10, 10, 80, 80);
    rotateImage(imgId, 90);
    flipImage(imgId, "h");
    grayscaleImage(imgId);
    blurImage(imgId, 3);
    invertImage(imgId);
    setPixelColor(imgId, 5, 5, "#FF0000");
    print("pixel(5,5)=" + getPixelColor(imgId, 5, 5));
    saveImage(imgId, "png", "test_img_out.png");
    var svgPath = imageToSvg(imgId, "test_img.svg");
    var fromSvgId = svgToImage(svgPath);
    print("svgPath=" + svgPath + " | svgToImage=" + fromSvgId);

    var b64Img = imageFileToBase64("test_sample.png");
    print("b64Img: valid=" + imageBase64Valid(b64Img) + ", mime=" + imageBase64Mime(b64Img) + ", size=" + imageBase64Size(b64Img) + ", WxH=" + imageBase64Width(b64Img) + "x" + imageBase64Height(b64Img));
    print("b64Info=" + imageBase64Info(b64Img));
    var uri = imageBase64Uri(b64Img);
    var cleaned = imageBase64Clean(uri);
    var resizedB64 = imageBase64Resize(cleaned, 64, 64);
    var squareB64 = imageBase64Square(cleaned, 50);
    imageBase64ToFile(squareB64, "test_b64_out.png");

    delete("test_img_out.png");
    delete("test_img.svg");
    delete("test_b64_out.png");
    pass("hql.image");
} catch (e) {
    fail("hql.image", e);
}

// ---------------------------------------------------------
// [13] HQL.GAME
// ---------------------------------------------------------
print("\n--- [13] HQL.GAME ---");
try {
    gameWindow("HQL Game Test", 320, 240);
    setTitle("HQL Game V2");
    setFPS(60);
    setFont("Arial", true);
    setAlpha(0.9);
    setStroke(2);
    clear("#101820");
    gradientRect(0, 0, 320, 240, "#101820", "#1e293b");
    drawRect(10, 10, 40, 40, "red");
    fillRect(60, 10, 40, 40, "#00ff00");
    drawCircle(130, 30, 15, "blue");
    fillCircle(170, 30, 15, "yellow");
    drawOval(10, 60, 40, 20, "white");
    fillOval(60, 60, 40, 20, "orange");
    drawRoundRect(110, 60, 40, 20, 6, "white");
    fillRoundRect(160, 60, 40, 20, 6, "#38bdf8");
    drawArc(210, 60, 30, 30, 0, 180, "white");
    fillArc(250, 60, 30, 30, 0, 180, "red");
    drawLine(0, 0, 100, 100, "white");
    fillTriangle(10, 120, 30, 100, 50, 120, "green");
    fillPolygon([60, 80, 90, 70], [100, 100, 120, 120], "yellow");
    drawPolygon([100, 120, 130, 110], [100, 100, 120, 120], "white");
    drawText("HQL", 10, 150, 16, "white");
    drawTextCenter("CENTER", 160, 170, 16, "yellow");
    print("textW=" + textWidth("HQL", 16) + " | getTextWidth=" + getTextWidth("HQL"));

    drawImage("test_sample.png", 10, 180, 32, 32);
    drawImageEx("test_sample.png", 50, 180, 32, 32, true, 45);
    print("imageReady=" + imageReady("test_sample.png"));

    sprite("sp1", 10, 10, 32, 32, "test_sample.png");
    moveTo("sp1", 20, 20);
    moveBy("sp1", 5, 5);
    rotateSprite("sp1", 90);
    scaleSprite("sp1", 40, 40);
    print("spritePos=" + spritePos("sp1") + " | collide=" + collide("sp1", "sp2"));
    removeSprite("sp1");

    pressKey("W");
    print("keyDown=" + isKeyDown("W") + ", keyPressed=" + isKeyPressed("W"));
    releaseKey("W");
    print("mouse=" + mouseX() + "," + mouseY() + " | down=" + isMouseDown("LEFT") + " | pressed=" + isMousePressed("LEFT"));
    print("screen=" + screenW() + "x" + screenH() + " | fps=" + getFPS() + " | dt=" + deltaTime() + " | frames=" + frameCount());
    print("mathGame: randInt=" + randomInt(1, 10) + ", randFloat=" + randomFloat(0, 1) + ", dist=" + distance(0, 0, 3, 4) + ", lerp=" + lerp(0, 10, 0.5) + ", angle=" + angleTo(0, 0, 1, 1));

    setCamera(5, 5);
    print("cam=" + camX() + "," + camY());
    beginUI();
    endUI();
    screenShake(4, 5);
    spawnParticle(50, 50, 1, -1, 4, 20, "orange", 0.1);
    burst(60, 60, 10, "yellow");
    floatText("+100", 60, 50, 14, "white");
    clearEffects();
    tone(440, 40, 0.2);

    mapNap(["#####", "#...#", "#.W.#", "#####"], 32, "#W", "#");
    print("map: " + mapSoCot() + "x" + mapSoHang() + " o=" + mapKichThuocO() + " tai(0,0)=" + mapO(0, 0) + " pixel=" + mapOTai(40, 40));
    mapDatO(2, 2, ".");
    print("mapThayDuoc=" + mapThayDuoc(40, 40, 100, 70) + " | banTia=" + banTia(40, 40, 0, 200));
    themKhoi(50, 50, 10);
    print("trongKhoi=" + trongKhoi(50, 50));
    xoaKhoiHet();

    isoCaiDat(64, 32);
    print("iso: X=" + isoX(32, 32) + ", Y=" + isoY(32, 32) + ", back=" + isoNguocVeTheGioi(isoManHinhX(32, 32), isoManHinhY(32, 32)));

    saveScreenshot("test_game_shot.png");
    delete("test_game_shot.png");
    closeGame();
    pass("hql.game");
} catch (e) {
    fail("hql.game", e);
}

// ---------------------------------------------------------
// [14] HQL.PC
// ---------------------------------------------------------
print("\n--- [14] HQL.PC ---");
try {
    print("mouse pos=" + pos());
    print("findPixel=" + findPixel("#000000", 0, 0, 50, 50));
    var oldClip = getClip();
    setClip("HQL_CLIP_TEST");
    print("clipboard=" + getClip());
    if (oldClip != null) { setClip(oldClip); }
    pass("hql.pc");
} catch (e) {
    fail("hql.pc", e);
}

// ---------------------------------------------------------
// [15] HQL.LOGGING
// ---------------------------------------------------------
print("\n--- [15] HQL.LOGGING ---");
try {
    setLogLevel("debug");
    setLogFile("test_hql.log");
    logDebug("Debug msg");
    logInfo("Info msg");
    logWarning("Warn msg");
    logError("Err msg");
    logReset();
    print("log file size=" + fileSize("test_hql.log"));
    delete("test_hql.log");
    pass("hql.logging");
} catch (e) {
    fail("hql.logging", e);
}

// ---------------------------------------------------------
// [16] HQL.CONFIG
// ---------------------------------------------------------
print("\n--- [16] HQL.CONFIG ---");
try {
    var confId = loadConfig("test_conf.ini");
    setConfig(confId, "App", "LinhScript");
    print("get=" + getConfig(confId, "App") + " | has=" + hasConfigKey(confId, "App") + " | keys=" + listConfigKeys(confId));
    removeConfigKey(confId, "App");
    setSectionConfig(confId, "DB", "Host", "localhost");
    setSectionConfig(confId, "DB", "Port", "1433");
    print("sec=" + getSectionConfig(confId, "DB", "Host") + " | secs=" + listSections(confId) + " | secKeys=" + listSectionKeys(confId, "DB"));
    saveConfig(confId, "test_conf.ini");
    removeSection(confId, "DB");
    delete("test_conf.ini");
    pass("hql.config");
} catch (e) {
    fail("hql.config", e);
}

// ---------------------------------------------------------
// [17] HQL.CSV
// ---------------------------------------------------------
print("\n--- [17] HQL.CSV ---");
try {
    writeCsvFile("test_1.csv", [["Ten", "Diem"], ["An", "8"], ["Binh", "9.5"], ["Chi", "7"]]);
    var csvData = readCsvFile("test_1.csv");
    print("rows=" + csvRowCount(csvData) + ", cols=" + csvColumnCount(csvData) + ", cell(1,0)=" + getCsvCell(csvData, 1, 0));
    setCsvCell(csvData, 1, 1, "8.5");
    addCsvRow(csvData, ["Dung", "6"]);
    removeCsvRow(csvData, 4);
    print("filterCol=" + filterCsvByColumn(csvData, 0, "An"));
    print("sortCol=" + sortCsvByColumn(csvData, 1, true));

    writeDelimitedFile("test_semi.csv", [["A", "B"], ["1", "2"]], ";");
    print("delimited=" + readDelimitedFile("test_semi.csv", ";"));

    var recs = readCsvRecords("test_1.csv");
    var newRec = addCsvRecord(recs);
    setCsvField(newRec, "Ten", "Em");
    setCsvField(newRec, "Diem", "10");
    print("getField=" + getCsvField(recs[0], "Ten"));
    sortCsvRecordsByField(recs, "Diem", false);
    print("filterField=" + filterCsvRecordsByField(recs, "Ten", "Em"));
    writeCsvRecords("test_2.csv", ["Ten", "Diem"], recs);
    removeCsvRecord(recs, 0);
    var fromJ = jsonToCsvRecords("[{\"Ten\":\"Lan\",\"Diem\":\"9\"}]");
    print("jsonToCsvRecords=" + fromJ);
    print("csvRecordsToJson=" + csvRecordsToJson(fromJ));

    delete("test_1.csv");
    delete("test_2.csv");
    delete("test_semi.csv");
    pass("hql.csv");
} catch (e) {
    fail("hql.csv", e);
}

// ---------------------------------------------------------
// [18] HQL.XML
// ---------------------------------------------------------
print("\n--- [18] HQL.XML ---");
try {
    var xmlStr = "<root><item id=\"1\"><ten>HQL</ten></item><item id=\"2\"><ten>Java</ten></item></root>";
    var x = xmlParseString(xmlStr);
    xmlWriteFile(x, "root", "test_x.xml");
    var xRead = xmlReadFile("test_x.xml");
    var rootNew = xmlCreateRoot("demo");
    print("xpathQuery=" + xmlXpathQuery("test_x.xml", "//item/ten"));
    print("xpathAttr=" + xmlXpathAttr("test_x.xml", "//item", "id"));
    print("findNodes=" + len(xmlFindNodes(x, "item")) + " | getNode=" + xmlGetNode(x, "item[0]/ten") + " | getAttr=" + xmlGetAttr(x, "item[0]", "id"));
    print("hasNode=" + xmlHasNode(x, "item[0]") + " | children=" + xmlChildrenCount(x, "item[0]"));
    xmlSetNode(x, "item[0]/ten", "LinhScript");
    xmlSetAttr(x, "item[0]", "ver", "1.0");
    xmlAddChild(x, "item[0]", xmlParseString("<note>OK</note>"));
    xmlRemoveAttr(x, "item[0]", "ver");
    xmlRemoveNode(x, "item[1]");
    print("toString len=" + len(xmlToString(x)) + " | toJson len=" + len(xmlToJson(x)));
    print("jsonToXml=" + jsonToXml("{\"item\":\"HQL\"}", "root"));
    xmlToCsv(xRead, "test_x.csv");
    var csvRecs = jsonToCsvRecords("[{\"a\":\"1\"}]");
    print("csvToXml=" + csvToXml(csvRecs, "root", "row"));

    delete("test_x.xml");
    delete("test_x.csv");
    pass("hql.xml");
} catch (e) {
    fail("hql.xml", e);
}

// ---------------------------------------------------------
// [19] HQL.BINARY
// ---------------------------------------------------------
print("\n--- [19] HQL.BINARY ---");
try {
    var fmt = ">i h b ? 4s";
    var hex = binaryPack(fmt, [1000, 7, 255, true, "AB"]);
    print("pack=" + hex + " | unpack=" + binaryUnpack(fmt, hex) + " | calcSize=" + binaryCalcSize(fmt));
    binaryWrite("test_b.bin", hex);
    print("read=" + binaryRead("test_b.bin") + " | size=" + binaryFileSize("test_b.bin") + " | byte0=" + binaryReadByte("test_b.bin", 0));
    binaryWriteByte("test_b.bin", 0, 170);
    binaryWriteBytes("test_b.bin", 0, "BEEF");
    print("readBytes=" + binaryReadBytes("test_b.bin", 0, 2));
    binaryPackToFile(">i", [42], "test_b2.bin");
    print("unpackFile=" + binaryUnpackFromFile(">i", "test_b2.bin"));
    print("hexToBytes=" + binaryHexToBytes("48656C6C6F") + " | bytesToHex=" + binaryBytesToHex([72, 101]));
    print("ops: slice=" + binarySlice(hex, 0, 4) + " | concat=" + binaryConcat("AA", "BB") + " | rep=" + binaryRepeat("AB", 3) + " | rev=" + binaryReverse("AABBCC") + " | xor=" + binaryXor("AA", "FF") + " | cmp=" + binaryCompare("AABB", "AACC"));
    var b64Bin = binaryToBase64("48656C6C6F");
    print("b64=" + b64Bin + " -> " + binaryFromBase64(b64Bin));
    print("hash: crc32=" + binaryCRC32(hex) + " | md5=" + binaryMD5(hex) + " | sha256=" + binarySHA256(hex));
    print("hexDump len=" + len(binaryHexDump("48656C6C6F", 8)));

    delete("test_b.bin");
    delete("test_b2.bin");
    pass("hql.binary");
} catch (e) {
    fail("hql.binary", e);
}

// ---------------------------------------------------------
// [20] HQL.COLOR
// ---------------------------------------------------------
print("\n--- [20] HQL.COLOR ---");
try {
    print("conv: hex=" + colorRgbToHex(255, 87, 51) + " | rgb=" + colorHexToRgb("#FF5733"));
    print("hsv=" + colorRgbToHsv(255, 87, 51) + " -> " + colorHsvToRgb(10.5, 0.8, 1.0));
    print("hsl=" + colorRgbToHsl(255, 87, 51) + " -> " + colorHslToRgb(10.5, 1.0, 0.6));
    print("cmyk=" + colorRgbToCmyk(255, 87, 51) + " -> " + colorCmykToRgb(0, 0.65, 0.8, 0));
    print("blend=" + colorBlend("#FF0000", "#0000FF", 0.5) + " | multi=" + colorMultiBlend(["#FF0000", "#00FF00", "#0000FF"], [1, 1, 1]));
    print("grad=" + colorGradient("#000000", "#FFFFFF", 3) + " | multiGrad=" + colorMultiGradient(["#FF0000", "#00FF00", "#0000FF"], 4) + " | randGrad=" + colorRandomGradient(3, 123));
    print("adj: light=" + colorLighten("#336699", 0.2) + " | dark=" + colorDarken("#336699", 0.2) + " | sat=" + colorSaturate("#336699", 0.2) + " | desat=" + colorDesaturate("#336699", 0.2) + " | hue=" + colorAdjustHue("#FF5733", 90));
    print("check: lum=" + colorLuminance("#FFFFFF") + " | contrast=" + colorContrastRatio("#FFFFFF", "#000000") + " | isLight=" + colorIsLight("#FFFFFF") + " | isDark=" + colorIsDark("#000000"));
    print("dist=" + colorDistance("#FF0000", "#800000") + " | sim=" + colorSimilarity("#FF0000", "#800000") + " | grey=" + colorToGreyscale("#FF5733"));
    print("gen: hex=" + colorRandomHex() + " | rgb=" + colorRandomRgb() + " | pal=" + colorRandomPalette(3, "analogous"));
    print("name: toRgb=" + colorNameToRgb("skyblue") + " | toName=" + colorRgbToName(135, 206, 235) + " | opacity=" + colorWithOpacity("#FF5733", 0.5));
    var palImg = loadImage("test_sample.png");
    print("extractPalette=" + colorExtractPalette(palImg, 3));
    delete("test_sample.png");
    pass("hql.color");
} catch (e) {
    fail("hql.color", e);
}

// ---------------------------------------------------------
// [21] HQL.SOCKET
// ---------------------------------------------------------
print("\n--- [21] HQL.SOCKET ---");
try {
    print("net: localIp=" + socketGetLocalIp() + " | host=" + socketGetHostName() + " | resolve=" + socketResolveHost("localhost") + " | ifaces=" + len(socketListInterfaces()) + " | ping=" + socketRawPing("127.0.0.1", 1000));
    var sv = socketTcpListen(19301);
    var cl = socketTcpConnect("127.0.0.1", 19301);
    var ac = socketTcpAccept(sv);
    socketSetTimeout(ac, 1000);
    socketSetTcpNoDelay(cl, true);
    socketSetKeepAlive(cl, true);
    print("status=" + socketTcpStatus(cl) + " | remote=" + socketGetRemoteIp(ac) + ":" + socketGetRemotePort(ac));
    socketTcpSend(cl, "HelloSocket!");
    var hasData = socketWaitData(ac, 1000);
    var recvHex = socketTcpReceive(ac, 100);
    print("TCP: wait=" + hasData + ", recvHex=" + recvHex);
    socketTcpClose(cl);
    socketTcpClose(ac);
    socketTcpClose(sv);

    var u = socketUdpBind(19302);
    socketSetTimeout(u, 1000);
    socketUdpSend(u, "127.0.0.1", 19302, "udp-ok");
    print("UDP recv=" + socketUdpReceive(u, 100));
    socketUdpClose(u);
    pass("hql.socket");
} catch (e) {
    fail("hql.socket", e);
}

// ---------------------------------------------------------
// [22] HQL.SCHEDULE
// ---------------------------------------------------------
print("\n--- [22] HQL.SCHEDULE ---");
try {
    print("cronValid=" + cronValidate("*/5 * * * *") + " | nextRun=" + cronNextRun("0 9 * * *"));
    taskRunOnce("t_once", "taskHello", 100);
    taskRepeat("t_rep", "taskHello", 150);
    taskSetMaxRuns("t_rep", 2);
    print("exists=" + taskExists("t_rep") + " | count=" + taskCount() + " | active=" + taskActiveCount());
    print("details=" + taskDetails("t_rep") + " | list=" + taskList());
    taskPause("t_rep");
    taskResume("t_rep");
    taskFireNow("t_rep");
    taskRunParallel(["taskJobA", "taskJobB"]);
    var lockOk = taskAcquireLock("t_lock", "test_hql.lock");
    taskReleaseLock("t_lock", "test_hql.lock");
    taskSaveState("test_tasks.json");
    sleep(400);
    print("taskDem=" + taskDem + " | runs=" + taskGetRuns("t_rep") + " | lock=" + lockOk);
    taskResetStats("t_rep");
    taskCancelAll();
    delete("test_tasks.json");
    delete("test_hql.lock");
    pass("hql.schedule");
} catch (e) {
    fail("hql.schedule", e);
}

// ---------------------------------------------------------
// [23] HQL.ENV
// ---------------------------------------------------------
print("\n--- [23] HQL.ENV ---");
try {
    envSet("HQL_TEST_STR", "LinhScript");
    envSet("HQL_TEST_INT", "2026");
    envSet("HQL_TEST_BOOL", "yes");
    print("has=" + envHas("HQL_TEST_STR") + " | get=" + envGet("HQL_TEST_STR") + " | def=" + envGet("HQL_NO_KEY", "mac_dinh"));
    print("int=" + envInt("HQL_TEST_INT", 0) + " | bool=" + envBool("HQL_TEST_BOOL", false) + " | req=" + envRequire("HQL_TEST_STR"));
    print("files=" + envFiles() + " | all=" + envAll());
    pass("hql.env");
} catch (e) {
    fail("hql.env", e);
}

// ---------------------------------------------------------
// [24] HQL.EXPORT
// ---------------------------------------------------------
print("\n--- [24] HQL.EXPORT ---");
try {
    var bang = [["Ten", "Diem", "Ghi chu"], ["An", 8, "Tot"], ["Binh", 5.5, "Can co gang"], ["Chi", 9.5, "Xuat sac"]];
    var opt = {
        "title": "BANG DIEM TEST",
        "subtitle": "LinhScript Auto Test",
        "zebra": true,
        "header": { "bg": "#1D4ED8", "color": "#FFFFFF" },
        "filter": true
    };
    exportXlsx(bang, "test_exp.xlsx", opt);
    exportDocx(bang, "test_exp.docx", opt);
    exportPdf(bang, "test_exp.pdf", opt);
    exportFile(bang, "test_exp.csv");
    print("exported sizes: xlsx=" + fileSize("test_exp.xlsx") + ", docx=" + fileSize("test_exp.docx") + ", pdf=" + fileSize("test_exp.pdf") + ", csv=" + fileSize("test_exp.csv"));
    delete("test_exp.xlsx");
    delete("test_exp.docx");
    delete("test_exp.pdf");
    delete("test_exp.csv");
    pass("hql.export");
} catch (e) {
    fail("hql.export", e);
}

// ---------------------------------------------------------
// [25] HQL.WEB
// ---------------------------------------------------------
print("\n--- [25] HQL.WEB ---");
try {
    print("utils: esc=" + htmlEscape("<b>Hi</b>") + " | enc=" + urlEncode("a b") + " | dec=" + urlDecode("a+b") + " | mime=" + webMime("a.png"));
    webRoute("/ping", "webPingRoute");
    webHienLoiChiTiet(true);
    webStart(19380, "/TestApp", ".");
    print("webContext=" + webContext());
    var webRes = httpGet("http://127.0.0.1:19380/TestApp/ping");
    print("GET /TestApp/ping -> " + webRes);
    webStop();

    wsStart(19381);
    print("WS clients=" + wsSoKetNoi() + " | broadcast=" + wsGuiTatCa("hello"));
    wsStop();
    pass("hql.web");
} catch (e) {
    fail("hql.web", e);
}

// ---------------------------------------------------------
// [26] HQL.MAIL
// ---------------------------------------------------------
print("\n--- [26] HQL.MAIL ---");
try {
    mailSenderName("LinhScript Tester");
    print("valid=" + mailIsValid("linh@example.com") + "/" + mailIsValid("sai_email"));
    print("otp=" + mailOtp(6) + " | pw=" + mailPassword(10) + " | configured=" + mailIsConfigured());
    mailClearAttach();
    print("mailError=" + mailError());
    pass("hql.mail");
} catch (e) {
    fail("hql.mail", e);
}

// ---------------------------------------------------------
// [27] HQL.MANG
// ---------------------------------------------------------
print("\n--- [27] HQL.MANG ---");
try {
    print("localIp=" + mangIpMay());
    mangMoServer(19305);
    var joined = mangKetNoi("127.0.0.1", 19305);
    sleep(200);
    var evJoin = mangNhan();
    mangGuiServer("CHAT_HELLO");
    sleep(200);
    var evMsg = mangNhan();
    print("mang: joined=" + joined + ", connected=" + mangDaNoi() + ", count=" + mangSoKhach() + ", list=" + mangDanhSachKhach());
    print("mang events: join=" + evJoin + ", msg=" + evMsg);
    if (len(evMsg) > 0) { mangGui(evMsg[0], "REPLY_OK"); }
    mangPhat("BROADCAST_OK");
    sleep(200);
    print("client recv1=" + mangNhanServer() + " | recv2=" + mangNhanServer());
    mangNgatKetNoi();
    mangDongServer();
    pass("hql.mang");
} catch (e) {
    fail("hql.mang", e);
}

// ---------------------------------------------------------
// [28] HQL.APP
// ---------------------------------------------------------
print("\n--- [28] HQL.APP ---");
try {
    print("hasBrowser=" + appCoTrinhDuyet() + " | javaHome=" + sysProp("java.home"));
    print("portOpen(19399)=" + congDangMo(19399) + " | waitPort(0.2s)=" + choCong(19399, 0.2));
    var pid = tienTrinhChay(["cmd", "/c", "ping", "-n", "2", "127.0.0.1"]);
    print("procId=" + pid + " | alive=" + tienTrinhSong(pid));
    tienTrinhTat(pid);
    pass("hql.app");
} catch (e) {
    fail("hql.app", e);
}

// ---------------------------------------------------------
// TONG KET KET QUA TEST
// ---------------------------------------------------------
print("\n=========================================================");
print("KET QUA TEST FULL LINHSCRIPT: PASS = " + passCount + " | FAIL = " + failCount);
if (failCount > 0) {
    print("DANH SACH NHOM LOI:");
    for errItem in failList {
        print("  - " + errItem);
    }
} else {
    print(">>> TAT CA CAC NHOM TEST DEU CHAY THONG! <<<");
}
print("=========================================================");

taskShutdown();
exit(0);