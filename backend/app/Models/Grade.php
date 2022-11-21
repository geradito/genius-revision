<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Grade extends Model
{
    use HasFactory;

    public function subjects()
    {
        return $this->hasMany('App\Models\Subject');
    }
    
    public function Category()
    {
        return $this->belongsTo('App\Model\Category');
    }
}
