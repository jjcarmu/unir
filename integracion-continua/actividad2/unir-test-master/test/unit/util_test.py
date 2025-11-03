import unittest
import pytest

from app import util


@pytest.mark.unit
class TestUtil(unittest.TestCase):
    def test_convert_to_number_correct_param(self):
        self.assertEqual(4, util.convert_to_number("4"))
        self.assertEqual(0, util.convert_to_number("0"))
        self.assertEqual(0, util.convert_to_number("-0"))
        self.assertEqual(-1, util.convert_to_number("-1"))
        self.assertAlmostEqual(4.0, util.convert_to_number("4.0"), delta=0.0000001)
        self.assertAlmostEqual(0.0, util.convert_to_number("0.0"), delta=0.0000001)
        self.assertAlmostEqual(0.0, util.convert_to_number("-0.0"), delta=0.0000001)
        self.assertAlmostEqual(-1.0, util.convert_to_number("-1.0"), delta=0.0000001)

    def test_convert_to_number_invalid_type(self):
        self.assertRaises(TypeError, util.convert_to_number, "")
        self.assertRaises(TypeError, util.convert_to_number, "3.h")
        self.assertRaises(TypeError, util.convert_to_number, "s")
        self.assertRaises(TypeError, util.convert_to_number, None)
        self.assertRaises(TypeError, util.convert_to_number, object())

    def test_invalid_convert_to_number_int(self):
        self.assertEqual(util.InvalidConvertToNumber("10"), 10)
        self.assertIsInstance(util.InvalidConvertToNumber("10"), int)

    def test_invalid_convert_to_number_float(self):
        self.assertEqual(util.InvalidConvertToNumber("10.5"), 10.5)
        self.assertIsInstance(util.InvalidConvertToNumber("10.5"), float)

    def test_invalid_convert_to_number_error(self):
        with self.assertRaisesRegex(TypeError, "Operator cannot be converted to number"):
            util.InvalidConvertToNumber("xyz")            

    def test_validate_permissions_success(self):
        self.assertTrue(util.validate_permissions("operation_mul", "user1"))

    def test_validate_permissions_failure(self):
        self.assertFalse(util.validate_permissions("operation_add", "user2"))
        self.assertFalse(util.validate_permissions("operation_div", "admin"))
        self.assertFalse(util.validate_permissions("operation_sub", None))