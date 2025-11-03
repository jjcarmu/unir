import http.client
import os
import unittest
from urllib.request import urlopen
import pytest

BASE_URL = os.environ.get("BASE_URL")
DEFAULT_TIMEOUT = 2  # in secs


@pytest.mark.api
class TestApi(unittest.TestCase):
    def setUp(self):
        self.assertIsNotNone(BASE_URL, "URL no configurada")
        self.assertTrue(len(BASE_URL) > 8, "URL no configurada")

    def test_api_add(self):
        url = f"{BASE_URL}/calc/add/2/2"
        response = urlopen(url, timeout=DEFAULT_TIMEOUT)
        self.assertEqual(
            response.status, http.client.OK, f"Error en la petición API a {url}"
        )

    def test_api_add_success(self):
        url = f"{BASE_URL}/calc/add/2/2"
        response = urlopen(url, timeout=DEFAULT_TIMEOUT)
        body = response.read().decode()
        
        self.assertEqual(response.status, http.client.OK)
        self.assertEqual(body, "4")

    def test_api_substract(self):
        url = f"{BASE_URL}/calc/substract/2/2"
        response = urlopen(url, timeout=DEFAULT_TIMEOUT)
        self.assertEqual(
            response.status, http.client.OK, f"Error en la petición API a {url}"
        )

    def test_api_substract_success(self):
        url = f"{BASE_URL}/calc/substract/10/5"
        response = urlopen(url, timeout=DEFAULT_TIMEOUT)
        body = response.read().decode()
        self.assertEqual(response.status, http.client.OK)
        self.assertEqual(body, "5")

    def test_api_multiply(self):
        url = f"{BASE_URL}/calc/multiply/2/2"
        response = urlopen(url, timeout=DEFAULT_TIMEOUT)
        self.assertEqual(
            response.status, http.client.OK, f"Error en la petición API a {url}"
        )

    def test_api_multiply_success(self):
        url = f"{BASE_URL}/calc/multiply/3/4"
        response = urlopen(url, timeout=DEFAULT_TIMEOUT)
        body = response.read().decode()

        self.assertEqual(response.status, http.client.OK)
        self.assertEqual(body, "12")

    def test_api_divide(self):
        url = f"{BASE_URL}/calc/divide/2/2"
        response = urlopen(url, timeout=DEFAULT_TIMEOUT)
        self.assertEqual(
            response.status, http.client.OK, f"Error en la petición API a {url}"
        )

    def test_api_divide_success(self):
        url = f"{BASE_URL}/calc/divide/10/2"
        response = urlopen(url, timeout=DEFAULT_TIMEOUT)
        body = response.read().decode()
        self.assertEqual(response.status, http.client.OK)
        self.assertEqual(body, "5.0")


    def test_api_power(self):
        url = f"{BASE_URL}/calc/power/2/2"
        response = urlopen(url, timeout=DEFAULT_TIMEOUT)
        self.assertEqual(
            response.status, http.client.OK, f"Error en la petición API a {url}"
        )

    def test_api_power_success(self):
        url = f"{BASE_URL}/calc/power/2/3"
        response = urlopen(url, timeout=DEFAULT_TIMEOUT)
        body = response.read().decode()
        self.assertEqual(response.status, http.client.OK)
        self.assertEqual(body, "8")

    def test_api_square_root(self):
        url = f"{BASE_URL}/calc/square_root/2"
        response = urlopen(url, timeout=DEFAULT_TIMEOUT)
        self.assertEqual(
            response.status, http.client.OK, f"Error en la petición API a {url}"
        )

    def test_api_square_root_success(self):
        url = f"{BASE_URL}/calc/square_root/9"
        response = urlopen(url, timeout=DEFAULT_TIMEOUT)
        body = response.read().decode()
        self.assertEqual(response.status, http.client.OK)
        self.assertEqual(body, "3.0")

    def test_api_log10(self):
        url = f"{BASE_URL}/calc/log10/100"
        response = urlopen(url, timeout=DEFAULT_TIMEOUT)
        self.assertEqual(
            response.status, http.client.OK, f"Error en la petición API a {url}"
        )

    def test_api_log10_success(self):
        url = f"{BASE_URL}/calc/log10/100"
        response = urlopen(url, timeout=DEFAULT_TIMEOUT)
        body = response.read().decode()
        self.assertEqual(response.status, http.client.OK)
        self.assertEqual(body, "2.0")

    """
    def test_api_divide_by_zero_failure(self):
        url = f"{BASE_URL}/calc/divide/1/0"
        # Usamos 'assertRaises' para verificar que se lanza una HTTPError
        with self.assertRaises(404) as e:
            urlopen(url, timeout=DEFAULT_TIMEOUT)
        # Verificamos el código de estado dentro de la excepción
        self.assertEqual(e.exception.code, http.client.BAD_REQUEST)
        # Verificamos el mensaje de error
        error_msg = e.exception.read().decode()
        self.assertEqual(error_msg, "Division by zero is not possible")

    def test_api_invalid_type_failure(self):
        url = f"{BASE_URL}/calc/add/abc/5"
        with self.assertRaises(urllib.error.HTTPError) as e:
            urlopen(url, timeout=DEFAULT_TIMEOUT)
        self.assertEqual(e.exception.code, http.client.BAD_REQUEST)
        error_msg = e.exception.read().decode()
        self.assertEqual(error_msg, "Operator cannot be converted to number")

    def test_api_sqrt_domain_failure(self):
        url = f"{BASE_URL}/calc/square_root/-9"
        with self.assertRaises(urllib.error.HTTPError) as e:
            urlopen(url, timeout=DEFAULT_TIMEOUT)
        self.assertEqual(e.exception.code, http.client.BAD_REQUEST)
        error_msg = e.exception.read().decode()
        self.assertEqual(error_msg, "Cannot calculate square root of a negative number")

    def test_api_log10_domain_failure(self):
        url = f"{BASE_URL}/calc/log10/0"
        with self.assertRaises(urllib.error.HTTPError) as e:
            urlopen(url, timeout=DEFAULT_TIMEOUT)
        self.assertEqual(e.exception.code, http.client.BAD_REQUEST)
        error_msg = e.exception.read().decode()
        self.assertEqual(error_msg, "Logarithm base 10 only defined for positive numbers")

    def test_api_not_found_failure(self):
        url = f"{BASE_URL}/ruta/que/no/existe"
        with self.assertRaises(urllib.error.HTTPError) as e:
            urlopen(url, timeout=DEFAULT_TIMEOUT)
        self.assertEqual(e.exception.code, http.client.NOT_FOUND)        
    """