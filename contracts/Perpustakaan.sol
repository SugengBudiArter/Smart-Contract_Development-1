// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// Definisikan kontrak Perpustakaan
contract Perpustakaan {
    struct Buku {
        string judul;
        uint256 tahunDibuat;
        string penulis;
    }

    mapping(uint256 => Buku) public bukuByISBN;
    address public admin = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    // Event untuk memberi tahu ketika buku ditambahkan atau diupdate
    event BukuDitambahkan(uint256 ISBN, string judul, uint256 tahunDibuat, string penulis);
    event BukuDiUpdate(uint256 ISBN, string judul, uint256 tahunDibuat, string penulis);
    event BukuDiHapus(uint256 ISBN);

    // Constructor akan dipanggil saat kontrak dibuat
    constructor() {
        admin = msg.sender;
    }

    // Modifikasi untuk memeriksa apakah pemanggil adalah admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Hanya admin yang dapat mengakses fungsi ini");
        _;
    }

    // Fungsi untuk menambah buku baru
    function tambahBuku(uint256 ISBN, string memory judul, uint256 tahunDibuat, string memory penulis) public onlyAdmin {
        require(bukuByISBN[ISBN].tahunDibuat == 0, "Buku dengan ISBN ini sudah ada");
        bukuByISBN[ISBN] = Buku(judul, tahunDibuat, penulis);

        // event ketika buku ditambahkan
        emit BukuDitambahkan(ISBN, judul, tahunDibuat, penulis);
    }

    // Fungsi untuk mengupdate buku berdasarkan ISBN
    function updateBuku(uint256 ISBN, string memory judul, uint256 tahunDibuat, string memory penulis) public onlyAdmin {
        require(bukuByISBN[ISBN].tahunDibuat != 0, "Buku dengan ISBN ini tidak ditemukan");
        bukuByISBN[ISBN] = Buku(judul, tahunDibuat, penulis);

        // event ketika buku diupdate
        emit BukuDiUpdate(ISBN, judul, tahunDibuat, penulis);
    }

    // Fungsi untuk menghapus buku berdasarkan ISBN
    function hapusBuku(uint256 ISBN) public onlyAdmin {
        require(bukuByISBN[ISBN].tahunDibuat != 0, "Buku dengan ISBN ini tidak ditemukan");
        delete bukuByISBN[ISBN];

        // event ketika buku dihapus
        emit BukuDiHapus(ISBN);
    }

    // Fungsi untuk mendapatkan data buku berdasarkan ISBN
    function getDataBukuByISBN(uint256 ISBN) public view returns (string memory, uint256, string memory) {
        require(bukuByISBN[ISBN].tahunDibuat != 0, "Buku dengan ISBN ini tidak ditemukan");
        Buku storage buku = bukuByISBN[ISBN];
        return (buku.judul, buku.tahunDibuat, buku.penulis);
    }
}
