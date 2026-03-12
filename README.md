# 🎵 MusicApp Valledupar

> **Aplicación móvil para facilitar la comunicación entre músicos y agrupaciones musicales en Valledupar.**
>
> Proyecto de grado — Ingeniería de Sistemas, Universidad Popular del Cesar  
> Autores: Kevin Manuel Castillo Aroca · Rubén Darío Ariza Valencia (2025–2026)

---

## 📁 Estructura del Proyecto

```
musicapp_valledupar/
├── lib/                          # Código Flutter (frontend)
│   ├── main.dart                 # Punto de entrada
│   ├── core/
│   │   ├── constants/            # AppConstants (géneros, instrumentos, etc.)
│   │   ├── errors/               # Failures y excepciones
│   │   ├── network/              # Interceptores Dio, SocketService
│   │   └── utils/                # Helpers, formateadores
│   ├── data/
│   │   ├── datasources/
│   │   │   ├── remote/           # Llamadas a la API REST
│   │   │   └── local/            # Caché con Hive / SharedPreferences
│   │   ├── models/               # Modelos JSON con serialización
│   │   └── repositories/         # Implementaciones de repositorios
│   ├── domain/
│   │   ├── entities/             # Usuario, Convocatoria, Mensaje, etc.
│   │   ├── repositories/         # Contratos (interfaces)
│   │   └── usecases/             # Casos de uso por feature
│   └── presentation/
│       ├── blocs/                # AuthBloc, PerfilBloc, ConvocatoriaBloc, ChatBloc
│       ├── screens/
│       │   ├── auth/             # Login, Registro, SeleccionRol, Splash
│       │   ├── home/             # Pantalla principal con navbar
│       │   ├── explore/          # Explorar músicos y agrupaciones
│       │   ├── profile/          # Ver y editar perfiles
│       │   ├── convocatoria/     # Listado, detalle, crear, mis postulaciones
│       │   └── chat/             # Conversaciones y chat en tiempo real
│       ├── widgets/              # Componentes reutilizables
│       ├── router/               # GoRouter con rutas y guards
│       └── theme/                # AppTheme (colores, tipografía Poppins)
│
├── backend/                      # API Node.js + MongoDB
│   └── src/
│       ├── server.js             # Entrada principal
│       ├── app.js                # Express + middlewares (seguridad, CORS, rate limiter)
│       ├── config/
│       │   ├── database.js       # Conexión MongoDB
│       │   └── socket.js         # Socket.IO (chat tiempo real)
│       ├── models/               # Esquemas Mongoose
│       │   ├── Usuario.js        # Músico / Agrupación
│       │   ├── PerfilMusico.js   # Galería, instrumentos, experiencia
│       │   ├── PerfilAgrupacion.js
│       │   ├── Convocatoria.js
│       │   ├── Postulacion.js
│       │   ├── Conversacion.js
│       │   └── Mensaje.js
│       ├── controllers/          # Lógica de negocio por recurso
│       ├── routes/               # Rutas Express
│       ├── middleware/           # auth.js, errorHandler, validar
│       ├── services/             # notificacion.service, cloudinary.service
│       └── utils/                # AppError, catchAsync, logger, seeder
│
├── assets/                       # Imágenes, íconos, fuentes
├── test/                         # Unit, widget e integration tests
├── pubspec.yaml                  # Dependencias Flutter
└── .env                          # Variables de entorno
```

---

## 🚀 Funcionalidades del MVP

### Para Músicos
- [x] Registro e inicio de sesión
- [x] Creación de perfil artístico (instrumentos, géneros, experiencia)
- [x] Galería multimedia (fotos y videos)
- [x] Explorar y buscar convocatorias con filtros
- [x] Postularse a convocatorias con mensaje de presentación
- [x] Ver estado de sus postulaciones
- [x] Chat directo con agrupaciones
- [x] Indicar disponibilidad

### Para Agrupaciones
- [x] Registro e inicio de sesión
- [x] Perfil de agrupación con logo y galería
- [x] Publicar convocatorias (instrumento, género, tipo de contrato)
- [x] Ver y gestionar postulaciones recibidas
- [x] Aceptar/rechazar postulaciones
- [x] Chat directo con músicos

### Características técnicas
- [x] Autenticación JWT con tokens seguros
- [x] Chat en tiempo real con Socket.IO
- [x] Notificaciones push con Firebase Cloud Messaging
- [x] Almacenamiento multimedia en Cloudinary
- [x] Búsqueda con índices de texto en MongoDB
- [x] Paginación en todos los listados

---

## ⚠️ Notas de compatibilidad — Flutter 3.41.4 / Dart 3.11

| Cambio                        | Detalle                                                                                    |
|------------------------------|--------------------------------------------------------------------------------------------|
| **SDK mínimo**               | `sdk: ">=3.11.0 <4.0.0"` — requerido por Flutter 3.41.x                                  |
| **`dartz` → `fpdart`**       | `dartz` no es compatible con Dart 3.x. Se usa `fpdart: ^1.1.1` que tiene API equivalente (`Either`, `Option`, etc.) |
| **`flutter_bloc` 9.x**       | La API es compatible con la 8.x salvo que `BlocProvider.of()` ahora prefiere `context.read<>()` |
| **`go_router` 17.x**         | La propiedad `subloc` fue renombrada a `matchedLocation`. Ya está corregido en `app_router.dart` |
| **`firebase_core` 4.x**      | Requiere `google-services.json` (Android) y `GoogleService-Info.plist` (iOS) actualizados para Firebase SDK v23+ |
| **`pull_to_refresh`**        | Eliminado — Flutter 3.x incluye `RefreshIndicator` nativo con soporte completo             |
| **`flutter_lints` 5.x**      | Incluye nuevas reglas para Dart 3.11 (dot shorthands, null-aware elements)                 |
| **Windows path limit**       | Instala Flutter en `C:\Flutter` para evitar errores por rutas largas en Windows            |

---

## ⚙️ Instalación y configuración

### Requisitos previos
- Flutter SDK `>=3.0.0`
- Node.js `>=18.x`
- MongoDB (local o MongoDB Atlas)
- Cuenta Cloudinary (multimedia)
- Proyecto Firebase (notificaciones push)

### Backend

```bash
cd backend
npm install
cp .env.example .env
# Editar .env con tus credenciales (MONGODB_URI, JWT_SECRET, CLIENT_ORIGIN)
npm run dev
```

### Configurar conexión a Mongo

Preferimos un `MONGODB_URI` completo (recomendado) o una lista separada de hosts en `MONGO_HOSTS` (coma-separados). Ejemplos en `backend/.env.example`.

Ejemplo de `MONGODB_URI` (Atlas):

```env
MONGODB_URI=mongodb+srv://user:pass@cluster0.mongodb.net/musicapp?retryWrites=true&w=majority
```

Ejemplo usando `MONGO_HOSTS` (fallbacks para redes/emuladores):

```env
MONGO_HOSTS=localhost:27017,10.0.2.2:27017
MONGO_DB=musicapp
```

Para probar la conexión y ver el estado, después de arrancar el backend visite:

```
curl http://localhost:3000/health
# -> { "status": "ok", "mongoReadyState": 1 }
```

### Flutter

### Flutter

```bash
# En la raíz del proyecto
cp .env.example .env
# Ajustar BASE_URL y SOCKET_URL
flutter pub get
flutter run
```

Nota: el cliente intentará resolver dinámicamente `BASE_URL` probando `/health`. No es necesario cambiar `BASE_URL` si está usando el emulador Android (usa `10.0.2.2`) o un dispositivo conectado al mismo host.

### Depurar instalación APK en dispositivo Android

Si la instalación falla con `INSTALL_FAILED_USER_RESTRICTED` o "Install canceled by user", revise lo siguiente en el dispositivo físico:

- Habilitar `USB debugging` en Opciones de desarrollador.
- Permitir "Instalar via USB" / "Instalar apps desconocidas" para la app que hace la instalación (Package Installer / Files).
- Revisar si existe un perfil de trabajo o políticas de empresa que bloqueen instalaciones.

Desde su máquina, verifique `adb` y liste dispositivos:

```powershell
adb devices
```

Si `adb` no se reconoce, añada Android SDK `platform-tools` a su PATH o use la ubicación del SDK, p. ej.

```powershell
# Ejemplo (ajuste la ruta a su SDK):
setx PATH "%PATH%;C:\Users\<usuario>\AppData\Local\Android\Sdk\platform-tools"
```

Si la instalación falla, capture logs:

```powershell
adb devices
adb -s <deviceId> logcat -v time > device-log.txt
# Intentar instalar de nuevo y revisar device-log.txt para ver la causa exacta
```

Si la política del dispositivo bloquea la instalación, pruebe instalar manualmente el APK desde el dispositivo o deshabilitar temporalmente la protección que impida instalaciones no aprobadas.


---

## 🗃️ Modelos de base de datos MongoDB

| Colección        | Descripción                                    |
|-----------------|------------------------------------------------|
| `usuarios`       | Cuentas de músicos y agrupaciones              |
| `perfilmusicos`  | Galería, instrumentos, géneros, experiencia    |
| `perfilagrupaciones` | Info de la banda/grupo, géneros, galería   |
| `convocatorias`  | Vacantes publicadas por agrupaciones           |
| `postulaciones`  | Músicos que aplican a una convocatoria         |
| `conversaciones` | Hilos de chat entre dos usuarios               |
| `mensajes`       | Mensajes individuales con soporte multimedia   |

---

## 🛠 Stack tecnológico

| Capa              | Tecnología                          | Versión          |
|------------------|-------------------------------------|------------------|
| Flutter SDK       | flutter_windows_3.41.4-stable       | 3.41.4           |
| Lenguaje          | Dart                                | 3.11.x           |
| State management  | flutter_bloc                        | ^9.1.1           |
| Navegación        | go_router                           | ^17.1.0          |
| HTTP / API        | dio + retrofit                      | ^5.7.0 / ^4.4.1  |
| Backend API       | Node.js + Express.js                | ≥18.x            |
| Base de datos     | MongoDB + Mongoose                  | ≥7.x             |
| Tiempo real       | Socket.IO                           | ^4.7.x           |
| Multimedia        | Cloudinary                          | —                |
| Push notifications| Firebase Cloud Messaging            | ^15.2.6          |
| Firebase Core     | firebase_core                       | ^4.4.0           |
| Autenticación     | JWT (jsonwebtoken)                  | ^9.x             |
| Análisis datos    | Power BI                            | —                |

---

## 📅 Cronograma de ejecución

| Fase                        | Período                          |
|-----------------------------|----------------------------------|
| Análisis y diseño           | 01 Dic – 24 Dic 2025             |
| Desarrollo MVP              | 26 Dic 2025 – 16 Feb 2026        |
| Pruebas funcionales         | 17 Feb – 05 Mar 2026             |
| Ajustes y mejoras           | 06 Mar – 25 Mar 2026             |
| Implementación y entrega    | 26 Mar – 30 Abr 2026             |

---

## 👥 Equipo

| Nombre                     | Cédula      | Contacto                    |
|---------------------------|-------------|------------------------------|
| Kevin Manuel Castillo Aroca | 1004307206 | kmcastillo@unicesar.edu.co  |
| Rubén Darío Ariza Valencia  | 1065840837 | rdariza@unicesar.edu.co     |

**Universidad Popular del Cesar — Facultad de Ingeniería de Sistemas**
