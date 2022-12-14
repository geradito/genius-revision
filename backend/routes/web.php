<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\GradeController;
use App\Http\Controllers\SubjectController;
use App\Http\Controllers\QuestionController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::get('/about', function () {
    return view('about');
});

Route::get('/privacy', function () {
    return view('privacy');
});

//documentation and api testing using swagger
Route::get('/docs', function () {
    return view('swagger.index');
});

Route::resource('categories', CategoryController::class);
Route::resource('grades', GradeController::class);
Route::resource('subjects', SubjectController::class);
Route::resource('questions', QuestionController::class);
