# Preserve the SQLCipher native bridge during release shrinking.
-keep class net.sqlcipher.** { *; }
-keep class net.zetetic.database.sqlcipher.** { *; }
