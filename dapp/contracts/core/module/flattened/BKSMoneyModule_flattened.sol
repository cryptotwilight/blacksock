
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
// File: contracts/interfaces/IBlackSock.sol


pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Core Interface
  * @author cryptotwilight
  * @dev This is the main access interface into the Black Sock decentralized social protocol
  * @custom:buidl'd at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
struct BlackSockStats { 

    uint256 profileCount; 
    uint256 createDate; 
}

interface IBlackSock { 
    
    function getStats() view external returns (BlackSockStats memory _stats);
    
    function isKnownOwner(address _user) view external returns (bool _isKnownOwner);

    function findProfile (address _user) view external returns (address _profile);

    function createProfile() external returns (address _profile);
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

// File: contracts/interfaces/module/IBKSModule.sol


pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Module
  * @author cryptotwilight
  * @dev This is the Super interface for all Modules in the Black Sock decentralized social protocol  
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */
interface IBKSModule { 

    function getOwner() view external returns (address _user);

    function isAdminEnabled() view external returns (bool _isEnabled);

    function enableAdmin(bool _enable) external returns (bool _adminEnabled);

}
// File: contracts/core/module/BKSModule.sol


pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Module 
  * @author cryptotwilight
  * @dev This is the Module super contract implementation for the Black Sock decentralized social protocol  
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */

abstract contract BKSModule is IBKSModule, IBKSVersion { 

    using Strings for address; 

    string constant BKS_ADMIN_CA = "BKS_ADMIN";
    string constant BLACK_SOCK_CA = "BLACK_SOCK_CORE";
    string constant BKS_REWARDS_SERVICE_CA = "BKS_REWARDS_SERVICE_CORE";

    uint256 private index; 

    modifier ownerOnly {
        require(isOwner(), string.concat( "owner only :x: ", msg.sender.toHexString()));
        _;
    }
    modifier adminOnly {
        require(adminEnabled && isAdmin(), string.concat( "admin only :x: ", msg.sender.toHexString()));
        _;
    }

    modifier admin() {
        require((adminEnabled && isAdmin()) || isOwner() , string.concat( "admin / owner only :x: ", msg.sender.toHexString()));
        _;
    }

    modifier rewarded( string memory _action) {
        _;
        IBlackSock system_ = IBlackSock(register.getAddress(BLACK_SOCK_CA));
        if(system_.isKnownOwner(owner)){
            IBKSRewardsService rewards_ = IBKSRewardsService(register.getAddress(BKS_REWARDS_SERVICE_CA));
            rewards_.issueReward(owner, _action);
        }
        
    }

    address owner; 
    bool private adminEnabled; 

    IBKSOpsRegister register; 
    IBKSModuleRegister mRegister; 

    constructor(address _owner, address _opsRegister, address _moduleRegister) { 
        owner = _owner; 
        register = IBKSOpsRegister(_opsRegister);
        mRegister = IBKSModuleRegister(_moduleRegister);
    }

    function getOwner() view external returns (address _owner) {
        return owner; 
    }

    function isAdminEnabled() view external returns (bool _isAdminEnabled) {
        return adminEnabled; 
    }

    function enableAdmin(bool _enable) external ownerOnly returns (bool _adminEnabled){
        adminEnabled = _enable;
        return adminEnabled; 
    }

    //======================================= INTERNAL ==============================================================

    function isOwner() internal view returns (bool _isOwner) {
        return msg.sender == owner; 
    }

    function isAdmin() internal view returns (bool _isAdmin) {
        return msg.sender == register.getAddress(BKS_ADMIN_CA);
    }

    function getIndex() internal returns (uint256 _index) {
        _index = index++;
        return _index; 
    }

}
// File: contracts/interfaces/module/IBKSMoneyModule.sol


pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Money Module 
  * @author cryptotwilight
  * @dev This is the Money Module that enables a user to create prices for various accesses to their Social Media such as sharing or advertising and enables a user to recieve, refund and withdraw payments.  
  * @custom:buidl at Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */

struct Payment {
    uint256 id; 
    string ref; 
    uint256 amount; 
    uint256 date; 
    address payee; 
    address payer;
    address paidBy; 
    address token; 
}

struct Price { 
    uint256 id; 
    string name; 
    uint256 amount; 
    address token;
}

interface IBKSMoneyModule is IBKSModule { 

    function getDefaultMoneyToken() view external returns (address _token);

    
    function getPriceNames() view external returns (string [] memory _priceNames);

    function hasPrice(string memory _priceName) view external returns (bool _hasPrice);

    function getPrice(string memory _priceName) view external returns (Price memory _price);

    function getPrices() view external returns (Price [] memory _price);

    function addPrice(Price memory _price) external returns (bool _added);
    
    function removePrice(string memory _name) external returns (Price memory _price);

    
    function getPayments() view external returns (Payment [] memory _payments);

    function getPayment(uint256 _pyamentId) view external returns (Payment memory _payment);

    function makePricedPayment(uint256 _priceId, address _payer) external payable returns (uint256 _paymentId);

    function makeRefPayment(string memory _ref, uint256 _amount, address _payer, address _token ) external payable returns (uint256 _paymentId);
    
    function makeRefund(uint256 _paymentId, string memory _reason) external returns (uint256 _refundPaymentId);

}
// File: contracts/core/module/BKSMoneyModule.sol


pragma solidity >=0.7.0 <0.9.0;
 /**
  * @title Black Sock - Money Module
  * @author cryptotwilight
  * @dev This is the Module implementation the Black Sock decentralized social protocol 
  * @custom:buidl Buidl Up 2023 https://www.buidlbox.io
  * @custom:contact @blockstarlogic1 (Twitter)
  */


contract BKSMoneyModule is BKSModule, IBKSMoneyModule {

    string constant vname = "BKS_MONEY_MODULE_NC";
    uint256 constant vversion = 1; 

    uint256 constant UNIT_MAX = 10;
    string constant DEFAULT_TOKEN_CA = "DEFAULT_TOKEN";
    address self; 

    string constant WITHDRAWAL_REF = "WITHDRAWAL";
    string constant REFUND_REF = "REFUND - ";

    string [] priceNames; 
    mapping(string=>bool) hasPriceByPriceName; 
    mapping(string=>Price) priceByName;
    mapping(uint256=>Price) priceById; 

    uint256 [] paymentIds; 
    mapping(uint256=>Payment) paymentById; 

    constructor(address _owner, address _opsRegister, address _moduleRegister)BKSModule(_owner, _opsRegister, _moduleRegister){
        self = address(this);
    }

    function getName() pure external returns (string memory _name){
        return vname; 
    }
    
    function getVersion() pure external returns (uint256 _version){
        return vversion; 
    }

    function getDefaultMoneyToken() view external returns (address _token){
        return register.getAddress(DEFAULT_TOKEN_CA);
    }
    
    function getPriceNames() view external returns (string [] memory _priceNames){
        return priceNames; 
    }

    function hasPrice(string memory _priceName) view external returns (bool _hasPrice) {
        return hasPriceByPriceName[_priceName];
    }

    function getPrice(string memory _priceName) view external returns (Price memory _price){
        return priceByName[_priceName];
    }

    function getPrices() view external  returns (Price [] memory _price){
        _price = new Price[](priceNames.length);
        for(uint256 x = 0; x < priceNames.length; x++) {
            _price[x] = priceByName[priceNames[x]];
        }
        return _price; 
    }

    function addPrice(Price memory _price) external adminOnly returns (bool _added){
        priceByName[_price.name] = Price({
                                            id : getIndex(),
                                            name : _price.name, 
                                            amount : _price.amount,
                                            token : _price.token
                                        }); 
        priceNames.push(_price.name);
        return true; 
    }
    
    function removePrice(string memory _name) external adminOnly returns (Price memory _price){
        _price = priceByName[_name];
        delete priceByName[_name];
        return _price; 
    }

    function getPayments() view external returns (Payment [] memory _payments){
        _payments = new Payment[](paymentIds.length);
        for(uint256 x = 0; x < paymentIds.length; x++) {
            _payments[x] = paymentById[paymentIds[x]];
        }
        return _payments; 
    }

    function getPayment(uint256 _paymentId) view external returns (Payment memory _payment){
        return paymentById[_paymentId];
    }

    function makePricedPayment(uint256 _priceId, address _payer) external payable returns (uint256 _paymentId){
        Price memory price_ = priceById[_priceId];
        return processPayment(price_.amount, self, _payer, msg.sender, price_.token, price_.name);
    }

    function makeRefPayment(string memory _ref, uint256 _amount, address _payer, address _token ) external payable returns (uint256 _paymentId){
        return processPayment(_amount, self, _payer, msg.sender, _token, _ref);
    }
    
    function makeRefund(uint256 _paymentId, string memory _reason) external adminOnly returns (uint256 _rPaymentId){
        Payment memory payment_ = paymentById[_paymentId];
        return processPayment(payment_.amount, payment_.payer, payment_.payee, self, payment_.token, string.concat(REFUND_REF, (string.concat(string.concat(_reason," - "),(payment_.ref)))));
    }


    function withdrawFunds(uint256 _amount, address _token) external ownerOnly returns (uint256 _paymentId) {
        return processPayment(_amount, msg.sender,  self, self,_token, WITHDRAWAL_REF );
    }

    //============================== INTERNAL ==========================================

    function processPayment(uint256 _amount,  address _payee, address _payer, address _paidBy,  address _token, string memory _ref ) internal returns (uint256 _paymentId ){
        _paymentId = getIndex(); 
        IERC20(_token).transferFrom(_paidBy, _payee, _amount);
        paymentIds.push(_paymentId);
        paymentById[_paymentId] = Payment({
                                        id      : _paymentId, 
                                        ref     : _ref, 
                                        amount  : _amount, 
                                        date    : block.timestamp,
                                        payee   : _payee,  
                                        payer   : _payer, 
                                        paidBy  : _paidBy, 
                                        token   : _token
                                    });
        return _paymentId; 
    }
}