plugins {
    kotlin("jvm") version "2.3.21"
    id("org.jetbrains.compose") version "1.10.1"
    id("org.jetbrains.kotlin.plugin.compose") version "2.3.21"
  }

repositories {
    mavenCentral()
    google()
  }

dependencies {
    implementation(compose.desktop.currentOs)
    implementation(compose.material3)
  }

kotlin {
  jvmToolchain(21)
  }

compose.desktop {
    application {
        mainClass = "MainKt"
    }
  }
