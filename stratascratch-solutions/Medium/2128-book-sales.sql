SELECT   b.book_id, COALESCE(SUM(b.unit_price*od.quantity), 0) as total_sales
FROM     amazon_books b LEFT JOIN amazon_books_order_details od ON b.book_id=od.book_id
GROUP BY b.book_id



-- NOTE: solved on first attempt