filepath = 'C:/Projects/GarudaOS/ProjectAirSim/unreal/Blocks/Plugins/ProjectAirSim/Source/ProjectAirSim/Private/UnrealLogger.h'
with open(filepath, 'rb') as f:
 data = f.read()
old = b'#elif UE_IS_5_2\r\n template <size_t N, typename... ArgTypes>\r\n static void Log(microsoft::projectairsim::LogLevel level,\r\n const TCHAR (&format)[N], ArgTypes... args);\r\n #endif\r\n\r\n static void LogSim'
new = b'#elif UE_IS_5_2\r\n template <size_t N, typename... ArgTypes>\r\n static void Log(microsoft::projectairsim::LogLevel level,\r\n const TCHAR (&format)[N], ArgTypes... args);\r\n #elif UE_IS_5_1\r\n template <typename... ArgTypes>\r\n static void Log(microsoft::projectairsim::LogLevel level,\r\n const TCHAR* format, ArgTypes... args);\r\n #endif\r\n\r\n static void LogSim'
if old in data:
 data = data.replace(old, new, 1)
 with open(filepath, 'wb') as f:
 f.write(data)
 print('SUCCESS')
else:
 print('ERROR: not found')
