"""Synthetic fixtures only: no personal data is needed to test the guard."""
from pathlib import Path
import tempfile
import unittest

from check_private_assets import find_private_assets, is_private_path


class PrivateAssetTests(unittest.TestCase):
    def test_sensitive_names_are_blocked(self):
        for path in [
            "assets/EXPORT.XML", "assets/export_cda.xml", "export.zip",
            "assets/apple_health_export/readme.txt", "private_health_data/data.json",
            "training_videos/clip.txt", "health_backup_2026.zip", "db/health.sqlite3",
            "db/health.db-wal", "db/health.sqlite-shm", "assets/video.MOV",
            "assets/a83f.healthbackup",
        ]:
            with self.subTest(path=path):
                self.assertTrue(is_private_path(path))

    def test_source_and_normal_assets_are_allowed(self):
        for path in ["lib/health/health_backup_service.dart", "assets/icon.png", "index.html"]:
            self.assertFalse(is_private_path(path))

    def test_xml_contents_detect_renamed_export(self):
        with tempfile.TemporaryDirectory(dir=Path.cwd()) as directory:
            root = Path(directory)
            (root / "renamed.xml").write_text('<HealthData locale="en_US"></HealthData>')
            (root / "ordinary.xml").write_text('<resources></resources>')
            self.assertEqual(
                find_private_assets([Path("renamed.xml"), Path("ordinary.xml")], root),
                [Path("renamed.xml")],
            )

    def test_namespaced_clinical_and_renamed_backup_are_blocked(self):
        with tempfile.TemporaryDirectory(dir=Path.cwd()) as directory:
            root = Path(directory)
            (root / "clinical.xml").write_text('<cda:ClinicalDocument xmlns:cda="urn:hl7-org:v3"/>')
            (root / "renamed.bin").write_text('{"format":"private-health","version":1}\n')
            self.assertEqual(
                find_private_assets([Path("clinical.xml"), Path("renamed.bin")], root),
                [Path("clinical.xml"), Path("renamed.bin")],
            )


if __name__ == "__main__":
    unittest.main()
