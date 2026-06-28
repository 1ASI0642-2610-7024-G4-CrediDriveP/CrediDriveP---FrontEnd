// ─────────────────────────────────────────────────────────────────────────────
// 🚨  BASE URL GLOBAL — CrediDriveP
// Descomenta la línea que corresponda a tu entorno y comenta las demás.
// ─────────────────────────────────────────────────────────────────────────────

// 1️⃣  Emulador Android  →  el emulador NO puede usar "localhost" directamente.
//     10.0.2.2 apunta al localhost de tu PC desde el emulador.
// const String kBaseUrl = 'http://10.0.2.2:5298/api';

// 2️⃣  Dispositivo físico  →  PC y dispositivo en la misma red Wi-Fi.
//     Reemplaza con tu IPv4 local (ipconfig / ifconfig).
// const String kBaseUrl = 'http://192.168.x.x:5298/api';

// 3️⃣  Web (Chrome/Edge en la misma máquina)
// const String kBaseUrl = 'http://127.0.0.1:5298/api';

// 4️⃣  Backend en Railway 🚂  ← ACTIVO AHORA
//     Reemplaza la URL con la tuya cuando la tengas lista.
// const String kBaseUrl = 'https://tu-proyecto.up.railway.app/api';

// ✅  ACTIVO — localhost ASP.NET Core en puerto 5298
const String kBaseUrl = 'https://credidrivep-backend-production.up.railway.app/api';

// ─────────────────────────────────────────────────────────────────────────────
// Otros valores globales
// ─────────────────────────────────────────────────────────────────────────────

/// Clave con la que se guarda el JWT en FlutterSecureStorage
const String kTokenKey = 'credidrivep_jwt';

/// Clave para guardar el rol del usuario
const String kRoleKey = 'credidrivep_role';

/// Clave para guardar el nombre del usuario
const String kUserNameKey = 'credidrivep_username';

/// Tiempo de espera para las peticiones HTTP (segundos)
const int kConnectTimeout = 15;
const int kReceiveTimeout = 15;
