#include "flutter_window.h"

#include <optional>
#include <algorithm>
#include <cwctype>
#include <filesystem>
#include <shellapi.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  // Windows is a device-only checkpoint app. FilePicker's Windows implementation
  // uses Dart FFI; cloud and Health plugins are intentionally not registered.
  flutter::MethodChannel<flutter::EncodableValue> video_channel(
      flutter_controller_->engine()->messenger(), "inbody/local_video",
      &flutter::StandardMethodCodec::GetInstance());
  video_channel.SetMethodCallHandler(
      [](const auto& call, auto result) {
        if (call.method_name() != "open") {
          result->NotImplemented();
          return;
        }
        const auto* argument = call.arguments();
        const auto* raw = argument ? std::get_if<std::string>(argument) : nullptr;
        if (!raw || raw->empty() || raw->find('\0') != std::string::npos) {
          result->Error("invalid_path", "Select a local video file.");
          return;
        }
        const auto path = std::filesystem::u8path(*raw);
        auto extension = path.extension().wstring();
        std::transform(extension.begin(), extension.end(), extension.begin(),
                       [](wchar_t c) { return static_cast<wchar_t>(towlower(c)); });
        std::error_code error;
        if (!path.is_absolute() || path.wstring().rfind(L"\\\\", 0) == 0 ||
            (extension != L".mp4" && extension != L".mov" && extension != L".m4v") ||
            !std::filesystem::is_regular_file(path, error)) {
          result->Error("invalid_path", "Video is unavailable or unsupported.");
          return;
        }
        const auto opened = reinterpret_cast<INT_PTR>(
            ShellExecuteW(nullptr, L"open", path.c_str(), nullptr, nullptr, SW_SHOWNORMAL));
        if (opened <= 32) {
          result->Error("open_failed", "Windows could not open the video.");
        } else {
          result->Success();
        }
      });
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
