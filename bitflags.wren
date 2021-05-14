class BitFlags {
    static hasFlag(val, mask) { val & mask == mask }

    static setFlag(val, mask) { val | mask }

    static unsetFlag(val, mask) { val & ~mask}

    static toggleFlag(val, mask) { val ^ mask}
}