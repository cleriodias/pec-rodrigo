<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SalaryAdvance extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'advance_date',
        'amount',
        'reason',
    ];

    protected $casts = [
        'advance_date' => 'date',
        'amount' => 'float',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
