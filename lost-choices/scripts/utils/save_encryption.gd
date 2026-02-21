## 存档加密工具
## 提供存档数据的加密和解密功能
class_name SaveEncryption

## 加密密钥（实际项目应从安全配置读取）
const KEY_SALT: String = "lost_choices_2026_protected"

## 加密数据
static func encrypt(data: String) -> String:
	if data.is_empty():
		return ""

	var key = _generate_key()
	var bytes = data.to_utf8_buffer()

	# XOR加密
	for i in range(bytes.size()):
		bytes[i] = bytes[i] ^ key[i % key.size()]

	return Marshalls.raw_to_base64(bytes)

## 解密数据
static func decrypt(encrypted_data: String) -> String:
	if encrypted_data.is_empty():
		return ""

	var key = _generate_key()
	var bytes = Marshalls.base64_to_raw(encrypted_data)

	# XOR解密
	for i in range(bytes.size()):
		bytes[i] = bytes[i] ^ key[i % key.size()]

	return bytes.get_string_from_utf8()

## 生成密钥
static func _generate_key() -> PackedByteArray:
	var key = KEY_SALT.sha256_text()
	return key.to_utf8_buffer()

## 计算数据Hash
static func calculate_hash(data: String) -> String:
	return data.sha256_text()

## 验证数据完整性
static func verify_integrity(data: String, hash_value: String) -> bool:
	return calculate_hash(data) == hash_value

## 加密字典数据（用于存档）
static func encrypt_data(data: Dictionary) -> String:
	var json_string = JSON.stringify(data)
	return encrypt(json_string)

## 解密字典数据（用于存档）
static func decrypt_data(encrypted_data: String) -> Dictionary:
	var json_string = decrypt(encrypted_data)
	if json_string.is_empty():
		return {}

	var json = JSON.new()
	if json.parse(json_string) == OK:
		return json.data
	return {}
