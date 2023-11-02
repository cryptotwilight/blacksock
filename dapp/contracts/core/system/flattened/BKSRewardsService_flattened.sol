
// File: @openzeppelin/contracts/utils/math/SignedMath.sol


// OpenZeppelin Contracts (last updated v5.0.0) (utils/math/SignedMath.sol)

pragma solidity ^0.8.20;

/**
 * @dev Standard signed math utilities missing in the Solidity language.
 */
library SignedMath {
    /**
     * @dev Returns the largest of two signed numbers.
     */
    function max(int256 a, int256 b) internal pure returns (int256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two signed numbers.
     */
    function min(int256 a, int256 b) internal pure returns (int256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two signed numbers without overflow.
     * The result is rounded towards zero.
     */
    function average(int256 a, int256 b) internal pure returns (int256) {
        // Formula from the book "Hacker's Delight"
        int256 x = (a & b) + ((a ^ b) >> 1);
        return x + (int256(uint256(x) >> 255) & (a ^ b));
    }

    /**
     * @dev Returns the absolute unsigned value of a signed value.
     */
    function abs(int256 n) internal pure returns (uint256) {
        unchecked {
            // must be unchecked in order to support `n = type(int256).min`
            return uint256(n >= 0 ? n : -n);
        }
    }
}

// File: @openzeppelin/contracts/utils/math/Math.sol


// OpenZeppelin Contracts (last updated v5.0.0) (utils/math/Math.sol)

pragma solidity ^0.8.20;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Muldiv operation overflow.
     */
    error MathOverflowedMulDiv();

    enum Rounding {
        Floor, // Toward negative infinity
        Ceil, // Toward positive infinity
        Trunc, // Toward zero
        Expand // Away from zero
    }

    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds towards infinity instead
     * of rounding towards zero.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        if (b == 0) {
            // Guarantee the same behavior as in a regular Solidity division.
            return a / b;
        }

        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a == 0 ? 0 : (a - 1) / b + 1;
    }

    /**
     * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or
     * denominator == 0.
     * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv) with further edits by
     * Uniswap Labs also under MIT license.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
            // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
            // variables such that product = prod1 * 2^256 + prod0.
            uint256 prod0 = x * y; // Least significant 256 bits of the product
            uint256 prod1; // Most significant 256 bits of the product
            assembly {
                let mm := mulmod(x, y, not(0))
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Handle non-overflow cases, 256 by 256 division.
            if (prod1 == 0) {
                // Solidity will revert if denominator == 0, unlike the div opcode on its own.
                // The surrounding unchecked block does not change this fact.
                // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
                return prod0 / denominator;
            }

            // Make sure the result is less than 2^256. Also prevents denominator == 0.
            if (denominator <= prod1) {
                revert MathOverflowedMulDiv();
            }

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [prod1 prod0].
            uint256 remainder;
            assembly {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator.
            // Always >= 1. See https://cs.stackexchange.com/q/138556/92363.

            uint256 twos = denominator & (0 - denominator);
            assembly {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by twos.
                prod0 := div(prod0, twos)

                // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0.
            prod0 |= prod1 * twos;

            // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
            // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv = 1 mod 2^4.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also
            // works in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2^8
            inverse *= 2 - denominator * inverse; // inverse mod 2^16
            inverse *= 2 - denominator * inverse; // inverse mod 2^32
            inverse *= 2 - denominator * inverse; // inverse mod 2^64
            inverse *= 2 - denominator * inverse; // inverse mod 2^128
            inverse *= 2 - denominator * inverse; // inverse mod 2^256

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
            // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /**
     * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
        uint256 result = mulDiv(x, y, denominator);
        if (unsignedRoundsUp(rounding) && mulmod(x, y, denominator) > 0) {
            result += 1;
        }
        return result;
    }

    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded
     * towards zero.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
     */
    function sqrt(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint256 result = 1 << (log2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        }
    }

    /**
     * @notice Calculates sqrt(a), following the selected rounding direction.
     */
    function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return result + (unsignedRoundsUp(rounding) && result * result < a ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 2 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     */
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return result + (unsignedRoundsUp(rounding) && 1 << result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 10 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     */
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10 ** 64) {
                value /= 10 ** 64;
                result += 64;
            }
            if (value >= 10 ** 32) {
                value /= 10 ** 32;
                result += 32;
            }
            if (value >= 10 ** 16) {
                value /= 10 ** 16;
                result += 16;
            }
            if (value >= 10 ** 8) {
                value /= 10 ** 8;
                result += 8;
            }
            if (value >= 10 ** 4) {
                value /= 10 ** 4;
                result += 4;
            }
            if (value >= 10 ** 2) {
                value /= 10 ** 2;
                result += 2;
            }
            if (value >= 10 ** 1) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return result + (unsignedRoundsUp(rounding) && 10 ** result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 256 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
     */
    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 16;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 8;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 4;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 2;
            }
            if (value >> 8 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + (unsignedRoundsUp(rounding) && 1 << (result << 3) < value ? 1 : 0);
        }
    }

    /**
     * @dev Returns whether a provided rounding mode is considered rounding up for unsigned integers.
     */
    function unsignedRoundsUp(Rounding rounding) internal pure returns (bool) {
        return uint8(rounding) % 2 == 1;
    }
}

// File: @openzeppelin/contracts/utils/Strings.sol


// OpenZeppelin Contracts (last updated v5.0.0) (utils/Strings.sol)

pragma solidity ^0.8.20;



/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant HEX_DIGITS = "0123456789abcdef";
    uint8 private constant ADDRESS_LENGTH = 20;

    /**
     * @dev The `value` string doesn't fit in the specified `length`.
     */
    error StringsInsufficientHexLength(uint256 value, uint256 length);

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        unchecked {
            uint256 length = Math.log10(value) + 1;
            string memory buffer = new string(length);
            uint256 ptr;
            /// @solidity memory-safe-assembly
            assembly {
                ptr := add(buffer, add(32, length))
            }
            while (true) {
                ptr--;
                /// @solidity memory-safe-assembly
                assembly {
                    mstore8(ptr, byte(mod(value, 10), HEX_DIGITS))
                }
                value /= 10;
                if (value == 0) break;
            }
            return buffer;
        }
    }

    /**
     * @dev Converts a `int256` to its ASCII `string` decimal representation.
     */
    function toStringSigned(int256 value) internal pure returns (string memory) {
        return string.concat(value < 0 ? "-" : "", toString(SignedMath.abs(value)));
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        unchecked {
            return toHexString(value, Math.log256(value) + 1);
        }
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        uint256 localValue = value;
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = HEX_DIGITS[localValue & 0xf];
            localValue >>= 4;
        }
        if (localValue != 0) {
            revert StringsInsufficientHexLength(value, length);
        }
        return string(buffer);
    }

    /**
     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal
     * representation.
     */
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), ADDRESS_LENGTH);
    }

    /**
     * @dev Returns true if the two strings are equal.
     */
    function equal(string memory a, string memory b) internal pure returns (bool) {
        return bytes(a).length == bytes(b).length && keccak256(bytes(a)) == keccak256(bytes(b));
    }
}

// File: contracts/interfaces/system/IBKSDirectory.sol


pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Directory
  * @author cryptotwilight
  * @dev This is the directory used to keep track of all user generated addresses in the Black Sock decentralized protocol 
  * @custom:buidl at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */

interface IBKSDirectory { 

    function getBKSAddresses() view external returns (address [] memory _addresses);

    function isBKSAddress(address _address) view external returns (bool _isBKSAddress);

    function getAddressOwner(address _address) view external returns (address _owner);

    function addBKSAddress(address _address, address _userOwner) external returns (bool _added);
}
// File: contracts/interfaces/system/IBKSOpsRegister.sol


pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Operations Register 
  * @author cryptotwilight
  * @dev This is the Operations Register that is used to keep track of all system level contracts in the Black Sock decentralized social protocol 
  * @custom:buidl at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
interface IBKSOpsRegister { 

    function getNames() view external returns (string [] memory _names);

    function getAddresses() view external returns (string [] memory _name, address [] memory _address);

    function getAddress(string memory _name) view external returns (address _address);

    function getName(address _address) view external returns (string memory _name);

    function isSystemAddress(address _address) view external returns (bool _isSystemAddress);

}
// File: contracts/interfaces/system/IBKSVersion.sol


pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Version
  * @author cryptotwilight
  * @dev This is the versioning and introspection interface used by the Black Sock decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
interface IBKSVersion { 

    function getName() view external returns (string memory _name);
    
    function getVersion() view external returns (uint256 _version);

}
// File: contracts/core/system/BKSSystemContract.sol


pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - System Contract
  * @author cryptotwilight
  * @dev This is the super contract for system contracts in the Black Sock decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */

abstract contract BKSSystemContract is IBKSVersion { 

    using Strings for address; 

    string constant BKS_DIRECTORY_CA = "BKS_DIRECTORY_CORE";
    string constant BKS_ADMIN_CA = "BKS_ADMIN";

    uint256 index; 

    modifier systemOnly() {
        require(register.isSystemAddress(msg.sender),string.concat("system only x  :x: ",msg.sender.toHexString()));
        _;
    }

    modifier adminOnly() { 
        require(msg.sender == register.getAddress(BKS_ADMIN_CA),string.concat("admin only x  :x: ",msg.sender.toHexString()));
        _;
    }

    modifier bksOnly() { 
        require (IBKSDirectory(register.getAddress(BKS_DIRECTORY_CA)).isBKSAddress(msg.sender), string.concat("unknown bks address :x: ",msg.sender.toHexString()));
        _;
    }

    IBKSOpsRegister register; 

    constructor(address _opsRegister) {
        register = IBKSOpsRegister(_opsRegister);
    }

    //========================== INTERNAL =======================

    function getIndex() internal returns (uint256 _index) {
        _index = index++;
        return _index; 
    }

}
// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: contracts/interfaces/module/IBKSModuleRegister.sol


pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Module Register
  * @author cryptotwilight
  * @dev This is the Module Register that is used to register an individual's modules in the Black Sock decentralized social protocol  
  * @custom:buidl at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
interface IBKSModuleRegister { 

    function getModule(uint256 _registrationId) view external returns (address _module);

    function getModules() view external returns (address [] memory _modules);

    function getModule(string memory _name) view external returns (address _module);

    function registerModule(address _module) external returns (uint256 _registrationId);

}
// File: contracts/interfaces/module/IBKSRewardModule.sol


pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Reward Module & Writer 
  * @author cryptotwilight
  * @dev This is the Reward Module used to present the user with an accounting of the rewards recieved and the Writer to the modul that enables the user to recieve and cash out rewards
  * @custom:buidl at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
struct Reward {
    uint256 id; 
    string action; 
    uint256 date; 
    uint256 amount; 
    address token; 
}

struct RewardsCashOut {
    uint256 id; 
    uint256 date; 
    uint256 amount; 
}
interface IBKSRewardModule { 

    function getRewardsToken() view external returns (address _token);

    function getRewardsBalance() view external returns (uint256 _rewards);

    function getRewardStatement() view external returns (Reward [] memory _rewards);

    function getReward(uint256 _rewardId) view external returns (Reward memory _reward);

}

interface IBKSRewardModuleWriter {

    function recieveReward(string memory _action, uint256 _amount) external payable returns (uint256 _rewardId);

    function cashOutReward(uint256 _amount) external returns (uint256 _cashoutId);
}
// File: contracts/interfaces/system/IBKSMintable.sol


pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Mintabble
  * @author cryptotwilight
  * @dev This is the minting interface for ERC20 fungible tokens used in the Black Sock protocol 
  * @custom:buidl'd at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
struct MintRecord { 
    uint256 id; 
    address mintedBy; 
    address mintedTo; 
    uint256 amount; 
    uint256 date; 
}

interface IBKSMintable { 

    function getMintRecordIds() view external returns (uint256 [] memory _mintRecordIds);

    function getMintRecord(uint256 _mintId) view external returns (MintRecord memory _mint);

    function mint(address to_, uint256 _amount) external returns (uint256 _mintId);

}
// File: contracts/interfaces/system/IBKSProfile.sol


pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Profile & Profile Writer
  * @author cryptotwilight
  * @dev This is the interface specification for an individual's Black Sock profile in the decentralized social protocol  
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
struct Avatar { 
    string name; 
    string image; 
}

struct Notification {
    uint256 id; 
    string notificationType; 
    uint256 date; 
    string content; 
}

interface IBKSProfile {

    function getAvatar() view external returns (Avatar memory _avatar);

    function getOwner() view external returns (address _owner);

    function getModuleRegister() view external returns (address _moduleRegister);

    function getNotifications() view external returns (Notification [] memory _notification);

}

interface IBKSProfileWriter{

    function setUserAvatar(Avatar memory _avatar) external returns (bool _set);

    function notify(Notification memory _notification) external returns (bool _notified);

}

// File: contracts/interfaces/system/IBKSProfileRegister.sol


pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Profile Register
  * @author cryptotwilight
  * @dev This is the decentralized register of all profiles active in the decentralized social protocol
  * @custom:buidl at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */

interface IBKSProfileRegister {

    function getProfile(uint256 _registrationId) view external returns (address _profile);

    function findProfileByOwner(address _owner) view external returns (address _profile);

    function findProfileByName(string memory _name) view external returns (address [] memory _profiles);

    function isRegisteredProfile(address _profile) view external returns (bool _isRegistered);

    function registerProfile(address _profile) external returns (uint256 _registrationId);
}
// File: contracts/interfaces/system/IBKSRewardsService.sol


pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Rewards Service
  * @author cryptotwilight
  * @dev This is the service that is responsible for issuing rewards to the users of the decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
interface IBKSRewardsService { 

    function issueReward(address _owner, string memory _action) external returns (uint256 _rewardId);

}
// File: contracts/core/system/BKSRewardsService.sol


pragma solidity >=0.8.2 <0.9.0;
 /**
  * @title Black Sock - Reward Service 
  * @author cryptotwilight
  * @dev This is the implementation contract for the Reward Service the Black Sock decentralized social protocol
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */

contract BKSRewardService is BKSSystemContract, IBKSRewardsService { 

    string constant name = "BKS_REWARD_SERVICE_CORE";
    uint256 constant version = 1; 

    string constant PROFILE_REWARD_MODULE_CA = "REWARD_MODULE_NC";
    string constant REWARD_TOKEN_CA = "BKS_REWARD_TOKEN_CORE";
    string constant PROFILE_REGISTER_CA = "PROFILE_REGISTER";

    address self; 

    string [] actions; 
    mapping(address=>uint256[]) rewardIdByOwner; 
    mapping(string=>uint256) rewardByAction; 
    mapping(address=>mapping(uint256=>uint256)) rewardByIdByOwner; 
    
    constructor(address _register) BKSSystemContract(_register) {
        self = address(this);
    }

    function getName() pure external returns (string memory _name){
        return name; 
    }
    function getVersion() pure external returns (uint256 _version){
        return version; 
    }

    function getRewardedActions() view external returns (string [] memory _actions) {
        return actions; 
    }

    function getRewardsForOwner(address _owner) view external returns (uint256 [] memory _rewards){
        return rewardIdByOwner[_owner];
    }

    function getRewardByIdByOwner(address _owner, uint256 _rewardId) view external returns (uint256 _amount) {
        return rewardByIdByOwner[_owner][_rewardId]; 
    }

    function issueReward(address _owner, string memory _action) external bksOnly returns (uint256 _rewardId){
        IBKSRewardModuleWriter rewardModule_ = IBKSRewardModuleWriter(IBKSModuleRegister(IBKSProfile(IBKSProfileRegister(register.getAddress(PROFILE_REGISTER_CA)).findProfileByOwner(_owner)).getModuleRegister()).getModule(PROFILE_REWARD_MODULE_CA));
        uint256 rewardAmount_ = rewardByAction[_action]; 
        if(rewardAmount_ == 0){
            return 0;
        }
        IBKSMintable(register.getAddress(REWARD_TOKEN_CA)).mint(self, rewardAmount_);
        IERC20(register.getAddress(REWARD_TOKEN_CA)).approve(address(rewardModule_), rewardAmount_);
        _rewardId = rewardModule_.recieveReward(_action, rewardAmount_);
        rewardIdByOwner[_owner].push(_rewardId);
        return _rewardId; 
    }

    function setRewardForAction(string memory _action, uint256 _amount) external adminOnly returns (bool _set) {
        rewardByAction[_action] = _amount; 
        return true;
    }
}