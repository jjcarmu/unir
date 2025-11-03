import unittest
from unittest.mock import patch
import pytest

from app.calc import Calculator, InvalidPermissions


def mocked_validation(*args, **kwargs):
    return True


@pytest.mark.unit
class TestCalculate(unittest.TestCase):
    def setUp(self):
        self.calc = Calculator()

    def test_add_method_returns_correct_result(self):
        self.assertEqual(4, self.calc.add(2, 2))
        self.assertEqual(0, self.calc.add(2, -2))
        self.assertEqual(0, self.calc.add(-2, 2))
        self.assertEqual(1, self.calc.add(1, 0))
        self.assertEqual(4.0, self.calc.add(1.5, 2.5))
        self.assertEqual(0, self.calc.add(0, 0))

    def test_substract_method_returns_correct_result(self):
        self.assertEqual(4, self.calc.substract(6, 2))
        self.assertEqual(0, self.calc.substract(2, 2))
        self.assertEqual(0, self.calc.substract(2, 2))
        self.assertEqual(1, self.calc.substract(1, 0))
        self.assertEqual(4.0, self.calc.substract(6.5, 2.5))
        self.assertEqual(0, self.calc.substract(0, 0))

    def test_divide_method_returns_correct_result(self):
        self.assertEqual(1, self.calc.divide(2, 2))
        self.assertEqual(1.5, self.calc.divide(3, 2))

    def test_power_method_returns_correct_result(self):
        self.assertEqual(1, self.calc.power(2, 0))
        self.assertEqual(2, self.calc.power(2, 1))
        self.assertEqual(4, self.calc.power(2, 2))
        self.assertEqual(8, self.calc.power(2, 3))
        self.assertEqual(9, self.calc.power(3, 2))
        self.assertEqual(3, self.calc.power(9, 0.5))
   
    def test_square_root_method_returns_correct_result(self):
        self.assertEqual(2, self.calc.square_root(4))
        self.assertEqual(3, self.calc.square_root(9))
        self.assertEqual(0, self.calc.square_root(0))
        self.assertEqual(1, self.calc.square_root(1))
        self.assertEqual(2.5, self.calc.square_root(6.25))

    def test_log10_method_returns_correct_result(self):
        self.assertEqual(1, self.calc.log10(10))
        self.assertEqual(2, self.calc.log10(100))
        self.assertEqual(0, self.calc.log10(1))

    def test_add_method_fails_with_nan_parameter(self):
        self.assertRaises(TypeError, self.calc.add, "2", 2)
        self.assertRaises(TypeError, self.calc.add, 2, "2")
        self.assertRaises(TypeError, self.calc.add, "2", "2")
        self.assertRaises(TypeError, self.calc.add, None, 2)
        self.assertRaises(TypeError, self.calc.add, 2, None)
        self.assertRaises(TypeError, self.calc.add, object(), 2)
        self.assertRaises(TypeError, self.calc.add, 2, object())

    def test_substract_method_fails_with_nan_parameter(self):
        self.assertRaises(TypeError, self.calc.substract, "2", 2)
        self.assertRaises(TypeError, self.calc.substract, 2, "2")
        self.assertRaises(TypeError, self.calc.substract, "2", "2")
        self.assertRaises(TypeError, self.calc.substract, None, 2)
        self.assertRaises(TypeError, self.calc.substract, 2, None)
        self.assertRaises(TypeError, self.calc.substract, object(), 2)
        self.assertRaises(TypeError, self.calc.substract, 2, object())

    def test_divide_method_fails_with_nan_parameter(self):
        self.assertRaises(TypeError, self.calc.divide, "2", 2)
        self.assertRaises(TypeError, self.calc.divide, 2, "2")
        self.assertRaises(TypeError, self.calc.divide, "2", "2")

    def test_divide_method_fails_with_division_by_zero(self):
        self.assertRaises(TypeError, self.calc.divide, 2, 0)
        self.assertRaises(TypeError, self.calc.divide, 2, -0)
        self.assertRaises(TypeError, self.calc.divide, 0, 0)
        self.assertRaises(TypeError, self.calc.divide, "0", 0)

    def test_square_root_method_fails_with_nan_parameter(self):
        self.assertRaises(TypeError, self.calc.square_root, -1)
        self.assertRaises(TypeError, self.calc.square_root, "0")
        self.assertRaises(TypeError, self.calc.square_root, None)
        self.assertRaises(TypeError, self.calc.square_root, object())

    def test_log10_root_method_fails_with_nan_parameter(self):
        self.assertRaises(TypeError, self.calc.log10, -1)
        self.assertRaises(TypeError, self.calc.log10, "0")
        self.assertRaises(TypeError, self.calc.log10, None)
        self.assertRaises(TypeError, self.calc.log10, object())

    @patch('app.util.validate_permissions', side_effect=mocked_validation, create=True)
    def test_multiply_method_returns_correct_result(self, _validate_permissions):
        self.assertEqual(4, self.calc.multiply(2, 2))
        self.assertEqual(0, self.calc.multiply(1, 0))
        self.assertEqual(0, self.calc.multiply(-1, 0))
        self.assertEqual(-2, self.calc.multiply(-1, 2))

    @patch('app.util.validate_permissions')
    def test_multiply_method_raises_invalid_permissions(self, mock_validate):
        mock_validate.return_value = False
        with self.assertRaisesRegex(InvalidPermissions, 'User has no permissions'):
            self.calc.multiply(3, 4)
        mock_validate.assert_called_once_with("3 * 4", "user1")    

if __name__ == "__main__":  # pragma: no cover
    unittest.main()
