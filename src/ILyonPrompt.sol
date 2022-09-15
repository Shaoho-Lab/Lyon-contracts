// SPDX-License-Identifier: MIT
// Creator: Lyon House

pragma solidity ^0.8.4;

/**
 * @dev Interface of Prompt.
 */
interface ILyonPrompt {
    /**
     * The caller must own the token or be an approved operator.
     */
    error ApprovalCallerNotOwnerNorApproved();

    /**
     * The token does not exist.
     */
    error ApprovalQueryForNonexistentToken();

    /**
     * Cannot query the balance for the zero address.
     */
    error BalanceQueryForZeroAddress();

    /**
     * Cannot mint to the zero address.
     */
    error MintToZeroAddress();

    /**
     * The quantity of tokens minted must be more than zero.
     */
    error MintZeroQuantity();

    /**
     * The token does not exist.
     */
    error OwnerQueryForNonexistentToken();

    /**
     * The token does not exist.
     */
    error URIQueryForNonexistentToken();

    /**
     * The `quantity` minted with ERC2309 exceeds the safety limit.
     */
    error MintERC2309QuantityExceedsLimit();

    /**
     * The `extraData` cannot be set on an unintialized ownership slot.
     */
    error OwnershipNotInitializedForExtraData();

    // =============================================================
    //                            STRUCTS
    // =============================================================

    enum ReplyType {
        YES,
        NO,
        DONTKNOW
    }

    struct PromptId {
        // The ID of the template. 第几个问题template
        uint256 templateId;
        // The ID of the token. 第几个用这个template问问题的
        uint256 indexId;
        // Whether the token has been burned.
        bool exists;
    }

    struct PromptInfo {
        // The address of the owner.
        address owner;
        // The SBT_question
        string question;
        // The address of the approved operator.
        mapping(string => ReplyInfo) replies;
        // The creation time of this Prompt.
        uint64 createTime;
        // Keys of replies
        string[] keys;
    }

    struct ReplyInfo {
        // TODO: 需要把 signature 放到这边。Question: 是否要把 endorser wallet address, endoresement text 等等也放进去

        // The reply detail.
        string reply;
        // Addtional comment
        string comment;
        // The creation time of this reply.
        uint256 createTime;
        // response type
        ReplyType replyType;
        // The address of replier
        address replier;
        // The hash of the commitment/signature
        uint256 signature;
    }

    // =============================================================
    //                         TOKEN COUNTERS
    // =============================================================

    /**
     * @dev Returns the total number of tokens in existence.
     * Burned tokens will reduce the count.
     * To get the total number of tokens minted, please see {_totalMinted}.
     */
    function totalSupply(uint256 templateId) external view returns (uint256);

    // =============================================================
    //                            IERC165
    // =============================================================

    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);

    // =============================================================
    //                            IERC721
    // =============================================================

    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    /**
     * @dev Emitted when `owner` enables or disables
     * (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    // TODO: 还需要几个 event 来显示 respond 了，以及 our protocol-specific functions.

    /**
     * @dev Returns the number of tokens in `owner`'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(PromptId calldata tokenId)
        external
        view
        returns (address owner);

    // /**
    //  * @dev Safely transfers `tokenId` token from `from` to `to`,
    //  * checking first that contract recipients are aware of the ERC721 protocol
    //  * to prevent tokens from being forever locked.
    //  *
    //  * Requirements:
    //  *
    //  * - `from` cannot be the zero address.
    //  * - `to` cannot be the zero address.
    //  * - `tokenId` token must exist and be owned by `from`.
    //  * - If the caller is not `from`, it must be have been allowed to move
    //  * this token by either {approve} or {setApprovalForAll}.
    //  * - If `to` refers to a smart contract, it must implement
    //  * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
    //  *
    //  * Emits a {Transfer} event.
    //  */
    // function safeTransferFrom(
    //     address from,
    //     address to,
    //     uint256 tokenId,
    //     bytes calldata data
    // ) external payable;

    // /**
    //  * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
    //  */
    // function safeTransferFrom(
    //     address from,
    //     address to,
    //     uint256 tokenId
    // ) external payable;

    // /**
    //  * @dev Transfers `tokenId` from `from` to `to`.
    //  *
    //  * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
    //  * whenever possible.
    //  *
    //  * Requirements:
    //  *
    //  * - `from` cannot be the zero address.
    //  * - `to` cannot be the zero address.
    //  * - `tokenId` token must be owned by `from`.
    //  * - If the caller is not `from`, it must be approved to move this token
    //  * by either {approve} or {setApprovalForAll}.
    //  *
    //  * Emits a {Transfer} event.
    //  */
    // function transferFrom(
    //     address from,
    //     address to,
    //     uint256 tokenId
    // ) external payable;

    // /**
    //  * @dev Gives permission to `to` to transfer `tokenId` token to another account.
    //  * The approval is cleared when the token is transferred.
    //  *
    //  * Only a single account can be approved at a time, so approving the
    //  * zero address clears previous approvals.
    //  *
    //  * Requirements:
    //  *
    //  * - The caller must own the token or be an approved operator.
    //  * - `tokenId` must exist.
    //  *
    //  * Emits an {Approval} event.
    //  */
    // function approve(address to, uint256 tokenId) external payable;

    // /**
    //  * @dev Approve or remove `operator` as an operator for the caller.
    //  * Operators can call {transferFrom} or {safeTransferFrom}
    //  * for any token owned by the caller.
    //  *
    //  * Requirements:
    //  *
    //  * - The `operator` cannot be the caller.
    //  *
    //  * Emits an {ApprovalForAll} event.
    //  */
    // function setApprovalForAll(address operator, bool _approved) external;

    // /**
    //  * @dev Returns the account approved for `tokenId` token.
    //  *
    //  * Requirements:
    //  *
    //  * - `tokenId` must exist.
    //  */
    // function getApproved(uint256 tokenId) external view returns (address operator);

    // /**
    //  * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
    //  *
    //  * See {setApprovalForAll}.
    //  */
    // function isApprovedForAll(address owner, address operator) external view returns (bool);

    // =============================================================
    //                        IERC721Metadata
    // =============================================================

    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(PromptId calldata tokenId)
        external
        view
        returns (string memory);

    // /**
    //  * @dev Requests 'to' to endorse 'from'.
    //  */
    // function requestEndorse(address from, address to, uint interval) external;

    // /**
    //  * @dev ‘to’ approves Prompt to 'from'.
    //  */
    // function approveEndorse(address from, address to) external;
}
